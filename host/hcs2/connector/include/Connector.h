/**
******************************************************************************
* @file Connector.h
* @author Prasanth Vivek
* $Rev: 1 $
* $Date: 2018-03-14
* @brief Abstract class for connector objects
******************************************************************************

* @copyright Copyright 2018 On Semiconductor
*/

#ifndef CONNECTOR_H__
#define CONNECTOR_H__

#include <iostream>
#include <string>
#include <stdlib.h>

#include <libserialport.h>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <cstdio>
#include <cstring>
#include <vector>
#include <chrono>

#include "zmq.hpp"
#include "zmq_addon.hpp"
#include "zhelpers.hpp"
#include <fcntl.h>   // File control definitions
#include <errno.h>   // Error number definitions

#include "rapidjson/document.h"

#ifdef _WIN32
#include <winsock2.h>
#include <windows.h>
#define sleep(n) Sleep(n*1000);
#else

#endif

// console prints
#define DEBUG 0
#define LOG_DEBUG(lvl, fmt, ...)						\
	do { if (lvl>0) fprintf(stderr, fmt, __VA_ARGS__); } while (0)

class Connector {
public:
    Connector() {}
    Connector(const std::string&) {}
    virtual ~Connector() {}

    virtual bool open(const std::string&) = 0;
    virtual bool close() = 0;

    virtual bool isPlatformAvailable()= 0;

    // non-blocking calls
    virtual bool send(const std::string& message) = 0;
    virtual bool read(std::string& notification) = 0;

    friend std::ostream& operator<< (std::ostream& stream, const Connector & c) {
        std::cout << "Connector: " << std::endl;
        std::cout << "  server: " << c.server_ << std::endl;
        return stream;
    }

    virtual int getFileDescriptor() = 0;

    void setDealerID(std::string id) {dealer_id_ = id;}
    std::string getDealerID() {return dealer_id_;}
    std::string getPlatformUUID() { return platform_uuid_;}
protected:
    std::string dealer_id_;
    std::mutex locker_;
    std::string platform_uuid_;
    std::string server_;
private:
};

class SerialConnector : public Connector {
public:
    SerialConnector();
    SerialConnector(const std::string&){}
    virtual ~SerialConnector(){}

    bool open(const std::string&);

    bool close();
    bool isPlatformAvailable();

    // non-blocking calls
    bool send(const std::string& message);

    bool read(std::string& notification);

    int getFileDescriptor();

    void windowsPlatformReadHandler();
    bool getPlatformID(std::string);
    bool isPlatformConnected();

private:
    struct sp_port *platform_socket_;
    struct sp_event_set *event_;
    int serial_fd_;	//file descriptor for serial ports
    std::thread *windows_thread_;
    std::condition_variable producer_consumer_;
    std::string platform_port_name_;
    // two bool variables used for producer consumer model required for windows
    bool produced_;
    bool consumed_;
    // integer variable used for wait timeout // required only for serial to socket
    int serial_wait_timeout_;

// #ifdef _WIN32
    zmq::context_t* context_;
    zmq::socket_t* write_socket_;   // After serial port read, writes to this socket
    zmq::socket_t* read_socket_;
// #endif
};

class ZMQConnector : public Connector {
public:
    ZMQConnector() {}
    ZMQConnector(const std::string&);
    virtual ~ZMQConnector() {}

    bool open(const std::string&);
    bool isPlatformAvailable(){}
    bool close(){}

    // non-blocking calls
    bool send(const std::string& message);
    bool read(std::string& notification);

    int getFileDescriptor();

private:
    zmq::context_t* context_;
    zmq::socket_t* socket_;
    std::string connection_interface_;
};

class ConnectorFactory {
public:
    static Connector *getConnector(const std::string& type) {
        std::cout << "ConnectorFactory::getConnector type:" << type << std::endl;
        if( type == "client") {
            return dynamic_cast<Connector*>(new ZMQConnector("local"));
        }
        else if( type == "remote") {
            return dynamic_cast<Connector*>(new ZMQConnector("remote"));
        }
        else if( type == "platform") {
            return dynamic_cast<Connector*>(new SerialConnector);
        }
        else {
            std::cout << "ERROR: ConnectorFactory::getConnector - unknown interface. " << type << std::endl;
        }
        return nullptr;
    }

private:
    // TODO use = delete
    ConnectorFactory() { std::cout << "ConnectorFactory: CTOR\n"; }
    virtual ~ConnectorFactory() { std::cout << "ConnectorFactory: DTOR\n"; }

};
#endif
