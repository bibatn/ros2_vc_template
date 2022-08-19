cmake_minimum_required(VERSION 3.5)
project([name])


# set this variable to ON in case of build real existing VisualCortex module
# also you must add corresponding libraries
set(REAL_MODULE OFF)

################# PLATFORM IDENTITY #################
set(PLATFORM 0)
if(${CMAKE_HOST_SYSTEM_PROCESSOR} STREQUAL x86_64)
  set(PLATFORM 1)
  add_definitions(-DPLATFORM=1)
  message("PLATFORM: x86_64")
elseif(${CMAKE_HOST_SYSTEM_PROCESSOR} STREQUAL aarch64)
  set(PLATFORM 2)
  add_definitions(-DPLATFORM=2)
  message("PLATFORM: aarch64")
else()
  message("UNKNOWN PLATFORM: " ${CMAKE_HOST_SYSTEM_PROCESSOR})
  return()
endif()

################# CMake config #################
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-unknown-pragmas")

# Флаги для дебага/релиза
#set(CMAKE_CXX_FLAGS_DEBUG   "-O0 -g3")
#set(CMAKE_CXX_FLAGS_RELEASE "-O3")

################# compiler config ##############
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CXX_EXTENSIONS OFF)
# Default to C99
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 99)
endif()

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

################# library config ###############
# OpenCVPROJECT_NAME
set(OpenCV_FOUND 1)
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

##Libraries
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(cv_bridge REQUIRED)
find_package(image_transport REQUIRED)
find_package(example_interfaces REQUIRED)
find_package(rclcpp_components REQUIRED)
find_package(rcutils)

message("PROJECT_NAME: " ${PROJECT_NAME})
message("PROJECT SOURCE DIR: " ${PROJECT_SOURCE_DIR})
message("OpenCV INCLUDE DIR: " ${OpenCV_INCLUDE_DIRS})
message("CMAKE_LIBRARY_OUTPUT_DIRECTORY: " ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

################# source config ################

##Paths
#Visual Cortex (change the path to your own if needed)
if(=${VC_ROOT_DIR}= STREQUAL ==)
    set(VC_ROOT_DIR /home/NAMI/marat.habibulin/projects/VisualCortex)
endif()
set(VC_SRC ${VC_ROOT_DIR}/src)
set(VC_INCLUDE ${VC_ROOT_DIR}/include)
file (GLOB SRC_LIST_VC ${VC_SRC}/*.cpp)
include_directories(${VC_INCLUDE})

if(REAL_MODULE STREQUAL ON)
##[name]
    set([NAME]_SRC ${VC_ROOT_DIR}/[name]/src)
    set([NAME]_INCLUDE ${VC_ROOT_DIR}/[name]/include)
    file (GLOB SRC_LIST_[NAME] ${[NAME]_SRC}/*.cpp)
    include_directories(${[NAME]_INCLUDE})
endif()

#ros_[name]
set(ROS_[NAME]_SRC ${PROJECT_SOURCE_DIR}/src)
file (GLOB SRC_LIST_ROS_[NAME] ${ROS_[NAME]_SRC}/*.cpp)

#insert your dependencies here

## Хедеры
include_directories(include)

set(LIBRARY_NAME ${PROJECT_NAME}_component)
add_library(${LIBRARY_NAME} SHARED
  ${SRC_LIST_ROS_[NAME]} ${SRC_LIST_VC} ${SRC_LIST_[NAME]})
ament_target_dependencies(${LIBRARY_NAME} rclcpp rclcpp_components example_interfaces std_msgs sensor_msgs cv_bridge image_transport OpenCV)
rclcpp_components_register_node(${LIBRARY_NAME}
  PLUGIN "ros_vc::[Name]Node"
  EXECUTABLE ${LIBRARY_NAME}1)

# OpenCV
target_link_libraries(${LIBRARY_NAME} ${OpenCV_LIBS})

# Boost (for example)
target_link_libraries(${LIBRARY_NAME} libboost_system.so)
target_link_libraries(${LIBRARY_NAME} libboost_filesystem.so)
target_link_libraries(${LIBRARY_NAME} libboost_log.so)
target_link_libraries(${LIBRARY_NAME} libboost_log_setup.so)
target_link_libraries(${LIBRARY_NAME} libboost_thread.so)
target_link_libraries(${LIBRARY_NAME} libpthread.so)            # Потоки
target_link_libraries(${LIBRARY_NAME} libboost_thread.so)
target_link_libraries(${LIBRARY_NAME} libboost_system.so)
target_link_libraries(${LIBRARY_NAME} libboost_regex.so)

# Libraries/Dependencies
if(REAL_MODULE STREQUAL ON)
    target_link_libraries(${LIBRARY_NAME} your_module_dependencies.so)
endif()

##Installation
#executables
install(TARGETS ${LIBRARY_NAME}1
  DESTINATION lib/${PROJECT_NAME})
install(TARGETS ${LIBRARY_NAME}
  LIBRARY DESTINATION lib)

set(LIBRARY_NAME ${PROJECT_NAME}_node) #Не обязательно чтобы совпадала с project_name.
add_executable(${LIBRARY_NAME} ${SRC_LIST_ROS_[NAME]} ${SRC_LIST_VC} ${SRC_LIST_[NAME]})
ament_target_dependencies(${LIBRARY_NAME} rclcpp std_msgs sensor_msgs cv_bridge image_transport OpenCV)

# OpenCV
target_link_libraries(${LIBRARY_NAME} ${OpenCV_LIBS})

# Boost (for example)
target_link_libraries(${LIBRARY_NAME} libboost_system.so)
target_link_libraries(${LIBRARY_NAME} libboost_filesystem.so)
target_link_libraries(${LIBRARY_NAME} libboost_log.so)
target_link_libraries(${LIBRARY_NAME} libboost_log_setup.so)
target_link_libraries(${LIBRARY_NAME} libboost_thread.so)
target_link_libraries(${LIBRARY_NAME} libpthread.so)            # Потоки
target_link_libraries(${LIBRARY_NAME} libboost_thread.so)
target_link_libraries(${LIBRARY_NAME} libboost_system.so)
target_link_libraries(${LIBRARY_NAME} libboost_regex.so)

# Libraries/Dependencies
if(REAL_MODULE STREQUAL ON)
    #target_link_libraries(${LIBRARY_NAME} your_module_dependencies.so)
endif()

install(TARGETS ${LIBRARY_NAME}
  DESTINATION lib/${PROJECT_NAME})



#launch files
install(DIRECTORY
  launch
  DESTINATION share/${PROJECT_NAME}
)


##Info
#Show all linked libraries
get_target_property(OUT ${LIBRARY_NAME} LINK_LIBRARIES)
message(STATUS "all linked libraries: " ${OUT})

##Конец
ament_package()
