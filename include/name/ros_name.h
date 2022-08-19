#ifndef ROS_IN_BASLER_H
#define ROS_IN_BASLER_H

#include <functional>
#include <memory>

#include <opencv2/highgui/highgui.hpp>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"
#include <image_transport/image_transport.h>
#include <cv_bridge/cv_bridge.h>
#include "rclcpp_components/register_node_macro.hpp"

#include "[name]/[name]_wrapper.h"

namespace ros_vc
{
class [Name]Node : public rclcpp::Node
{

public:
  [Name]Node(const rclcpp::NodeOptions & options);
  ~[Name]Node();

private:
  [Name]Wrapper wrap_;
  std::string paramsYml;
};

}

#endif // ROS_[NAME]_H
