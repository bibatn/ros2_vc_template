#ifndef [NAME]_WRAPPER_H
#define [NAME]_WRAPPER_H
#include "parameters.h"
//#include "[name].h" //Сначало нужно добавить зависимости твоего модуля

#include "image_transport/image_transport.h"
#include <cv_bridge/cv_bridge.h>

using namespace vision;

// Reimplementation of [Name] class for having access to protected methods
#define Impl(Class) Class##Impl

#define DerivedClass(Name) \
class Impl(Name) :  public Name \
{   \
  public: \
  Impl(Name)(unsigned int /*in*/id, PLogger& logger, Parameters* global, MessageController* controller) : \
  Name(id, logger, global, controller) {} \
  ~Impl(Name)() {} \
  using Name::onInit; \
  using Name::onGrab; \
  using Name::onMessage; \
  using Name::validateGrab; \
  using Name::validateMessage; \
  using Name::output_; \
}

//DerivedClass([Name]);

//wrapper class for [Name]
class [Name]Wrapper
{
public:
  //[Name] stuff
//  PLogger plogger;
//  MessageController msgCtrlr;
//  Parameters params = Parameters();
//  //[Name] itself
//  std::shared_ptr<Impl([Name])> [name]_ = std::make_shared<Impl([Name])>(0, plogger, &params, &msgCtrlr);

  //Load [Name] parameters from visual cortex yml structure
  void loadFromFile(const std::string& filename, vision::Parameters& params);

  std::string mat_type2encoding(int mat_type);

  //to publish [Name] results
  image_transport::Publisher pub;

  //[Name] results to publish
  std::vector<sensor_msgs::msg::Image::ConstSharedPtr> outMessages;

  //initialize [Name]
  void init(const std::string& paramsYml);

  //callback function called when a new image for processing comes
  void imageCallback();
};


#endif // [NAME]_WRAPPER_H
