cmake_minimum_required(VERSION 3.0.2)
project(industrial_robotics)

find_package(catkin REQUIRED COMPONENTS
  rospy
  message_generation
  std_msgs
)


generate_messages(
  DEPENDENCIES
  std_msgs
)

catkin_package(
)

include_directories(
# include
  ${catkin_INCLUDE_DIRS}
)