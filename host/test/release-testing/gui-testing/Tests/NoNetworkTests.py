'''
Tests involving interacting with elements while not connected to the network
'''
import unittest
import GUIInterface.Login as login
import GUIInterface.General as general
import GUIInterface.Register as register
import Common
import pyautogui

class NoNetworkLogin(unittest.TestCase):
    '''
    Test logging in while disconnected from the network
    '''
    def setUp(self) -> None:
        with general.Latency(Common.ANIMATION_LATENCY):
            login.setToLoginTab()
    def tearDown(self) -> None:
        general.deleteTextAt(login.findUsernameInput())

        # Wait for error to dissapear
        pyautogui.sleep(0.5)

        general.deleteTextAt(login.findPasswordInput())

    def test_no_network_login(self):

        #assert on login page
        self.assertIsNotNone(general.tryRepeat(login.findUsernameInput))

        login.login(Common.VALID_USERNAME, Common.VALID_PASSWORD)

        self.assertIsNotNone(general.tryRepeat(login.findNetworkError, 0.5, 10))

class NoNetworkRegister(unittest.TestCase):
    def setUp(self) -> None:
        with general.Latency(Common.ANIMATION_LATENCY):
            register.setToRegisterTab()
    def tearDown(self) -> None:
        pass

    def test_no_network_register(self):

        #assert on register page
        self.assertIsNotNone(general.tryRepeat(register.findRegisterAgreeCheckbox))

        register.fillRegistration("Testy", "McTest", "ON Semiconductor", "Test Engineer", Common.VALID_PASSWORD, Common.VALID_USERNAME)

        self.assertIsNotNone(general.tryRepeat(register.findSubmitEnabled))
        general.clickAt(general.tryRepeat(register.findSubmitEnabled))

        self.assertIsNotNone(general.tryRepeat(register.findNetworkError, 0.5, 15))
