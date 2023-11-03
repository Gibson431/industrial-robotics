#!/usr/bin/env python3

import rospy
from tm_msgs.srv import SendScript, SendScriptRequest
from std_srvs.srv import Trigger, TriggerResponse

states = ["Open", "Closed"]
state = 0

def gripperCallback(req):
    msg = SendScriptRequest()
    msg.id = 'ExitListener'
    msg.script = 'ScriptExit()'
    grip(msg)
    foo = "Gripper is now " + states[state]
    state != state
    return TriggerResponse(success=True, message=foo)


if __name__ == "__main__":
    rospy.init_node("ROSCom")
    rospy.loginfo("TM5 Communicator started")
    print('adsfg')
    gripListen = rospy.Service('gripper_serv', Trigger, gripperCallback)
    grip = rospy.ServiceProxy('tm_driver/send_script', SendScript)
    
    while not rospy.is_shutdown():
        pass