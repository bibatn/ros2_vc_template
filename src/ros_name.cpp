#include"[name]/ros_[name].h"

namespace ros_vc
{
[Name]Node::[Name]Node(const rclcpp::NodeOptions & options)
  : Node("[name]_node",options)
  {
    try
    {
    this->declare_parameter("paramsYml");
    this->get_parameter_or<std::string>("paramsYml", paramsYml,"");
    wrap_.init(paramsYml);

    auto it = new image_transport::ImageTransport(static_cast<rclcpp::Node::SharedPtr>(this));
    wrap_.pub = it->advertise("[name]",1);
    //запуск кода из imageCallback
    }
    catch(std::runtime_error& err)
    {
      std::cout << err.what() << ",  ВСЕ ПРОПАЛО"<<std::endl;
//      rclcpp::shutdown(); //Если модуль критически важен.
    }
  }

[Name]Node::~[Name]Node()
{
}

}

RCLCPP_COMPONENTS_REGISTER_NODE(ros_vc::[Name]Node)
