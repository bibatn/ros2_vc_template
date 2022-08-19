#include <numeric>
#include <fstream>
#include <iterator>
#include <string>
#include <stdexcept>

#include "[name]/[name]_wrapper.h"

#include "vision.h"

using std::cout;
using std::endl;

void [Name]Wrapper::loadFromFile(const std::string& filename, vision::Parameters& params)
{
  cv::String fstr(filename.c_str());

  cv::FileStorage fs;
  if (!fs.open(fstr, cv::FileStorage::READ | cv::FileStorage::FORMAT_YAML))
  {
    throw std::runtime_error("Couldn't load structure file");
    //exit(1);
  }
  cv::FileNode modules = fs["modules"];

  //loop over the all modules
  for (auto it : modules)
  {
    //int id = static_cast<int>(it["id"]);
    std::string type = static_cast<std::string>(it["type"]);

    //look for parameters of the [Name] module
    if(type == "[name]")
    {
      std::map<std::string, std::string> parmap;
      cv::FileNode parnode = it["parameters"];
      ///TODO: добавить сигнатуры шаблонных функций Parameters::get<>() в parameters.h
      for (auto it_par : parnode)
      {
        std::string key = it_par.name();
        if(it_par.isString())
        {
          std::string val = (std::string)it_par;
          if(val == "true" || val == "false")
          {
            params.set(key, val == "true");
          }
          else
          {
            params.set(key, (std::string)it_par);
          }
        }
        else if (it_par.isInt())
        {
          params.set(key, static_cast<int>(it_par));
        }
        else if (it_par.isReal())
        {
          params.set(key, (double)it_par);
        }
      }
    }

  }

}

void [Name]Wrapper::init(const std::string &paramsYml)
{
//  // load parameters from the structure
//  this->loadFromFile(paramsYml, params);

//  // initialize
//  if([name]_->onInit(params) == ST_FAIL)
//  {
//    cout << "Couldn't init node [Name]!" << endl;
//    throw std::runtime_error("Can't create [Name]Node!");
//  }
}



std::string [Name]Wrapper::mat_type2encoding(int mat_type)
{
  std::string Res;
  switch (mat_type)
  {
    case CV_8UC1:
      Res = "mono8";
      break;

    case CV_8UC3:
      Res = "bgr8";
      break;

    case CV_16SC1:
      Res = "mono16";
      break;

    case CV_8UC4:
      Res = "rgba8";
      break;

    default:
      throw std::runtime_error("Unsupported encoding type");
  }
  return Res;
}

void [Name]Wrapper::imageCallback()
{
// Здесь нужно вызвать onGrab() либо onMessage() в зависимости от вашего модуля
}
