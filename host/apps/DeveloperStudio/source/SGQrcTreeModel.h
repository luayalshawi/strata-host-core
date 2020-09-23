#pragma once

#include "SGQrcTreeNode.h"

#include <QAbstractItemModel>
#include <QVariant>
#include <QHash>
#include <QUrl>
#include <QDomDocument>
#include <QSet>
#include <QFileInfo>
#include <QQmlListProperty>
#include <QSortFilterProxyModel>

class SGQrcTreeModel : public QAbstractItemModel
{
    Q_OBJECT
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(SGQrcTreeNode* root READ root NOTIFY rootChanged)
    Q_PROPERTY(QUrl projectDirectory READ projectDirectory NOTIFY projectDirectoryChanged)
    Q_PROPERTY(QList<SGQrcTreeNode*> childNodes READ childNodes)
    Q_PROPERTY(QList<SGQrcTreeNode*> openFiles READ openFiles NOTIFY openFilesChanged)
public:
    explicit SGQrcTreeModel(QObject *parent = nullptr);
    ~SGQrcTreeModel();

    enum RoleNames {
        FilenameRole = Qt::UserRole + 1,
        FilepathRole = Qt::UserRole + 2,
        FileTypeRole = Qt::UserRole + 3,
        VisibleRole = Qt::UserRole + 4,
        OpenRole = Qt::UserRole + 5,
        InQrcRole = Qt::UserRole + 6,
        IsDirRole = Qt::UserRole + 7,
        ChildrenRole = Qt::UserRole + 8,
        ParentRole = Qt::UserRole + 9,
        UniqueIdRole = Qt::UserRole + 10
    };
    Q_ENUM(RoleNames);

    // OVERRIDES
    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::UserRole) const override;
    Q_INVOKABLE bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    Q_INVOKABLE int rowCount(const QModelIndex &index = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    bool removeRows(int row, int count = 1, const QModelIndex &parent = QModelIndex()) override;
    Q_INVOKABLE QModelIndex index(int row, int column = 0, const QModelIndex &parent = QModelIndex()) const override;
    Q_INVOKABLE QModelIndex parent(const QModelIndex &child) const override;
    Q_INVOKABLE bool hasChildren(const QModelIndex &parent = QModelIndex()) const override;

    bool insertChild(SGQrcTreeNode *child, const QModelIndex &parent = QModelIndex(), int position = -1);
    QList<SGQrcTreeNode*> childNodes();
    Q_INVOKABLE SGQrcTreeNode* get(int uid) const;

    /**
     * @brief readQrcFile Reads a .qrc file and populates the model
     */
    void readQrcFile(QSet<QString> &qrcItems);

    /**
     * @brief url Returns the url to the .qrc file
     * @return The url to the .qrc file
     */
    QUrl url() const;

    /**
     * @brief projectDirectory Returns the url to the project root directory
     * @return The url to the project root directory
     */
    QUrl projectDirectory() const;

    /**
     * @brief setUrl Sets the url of the .qrc file
     * @param url The url to set
     */
    void setUrl(QUrl url);

    QList<SGQrcTreeNode *> openFiles() const;
    Q_INVOKABLE void addOpenFile(SGQrcTreeNode* item);
    Q_INVOKABLE void removeOpenFile(SGQrcTreeNode* item);
    Q_INVOKABLE int findOpenFile(int uid);

    SGQrcTreeNode* root() const;
    Q_INVOKABLE SGQrcTreeNode* getNode(const QModelIndex &index) const;

signals:
    void urlChanged();
    void projectDirectoryChanged();
    void rootChanged();
    void dataReady();
    void addedOpenFile(SGQrcTreeNode* item);
    void removedOpenFile(int index);
    void openFilesChanged();

public slots:
    void childrenChanged(const QModelIndex &index, int role);

private:
    void clear(bool emitSignals = true);
    void setupModelData();
    void createModel();
    void recursiveDirSearch(SGQrcTreeNode *parentNode, QDir currentDir, QSet<QString> qrcItems, int depth);
    SGQrcTreeNode *root_;
    QUrl url_;
    QUrl projectDir_;
    QDomDocument qrcDoc_;
    QVector<SGQrcTreeNode*> uidMap_;
    QList<SGQrcTreeNode*> openFiles_;
};
