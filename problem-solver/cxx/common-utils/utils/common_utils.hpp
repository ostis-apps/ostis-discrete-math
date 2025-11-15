
#pragma once

#include <string>
#include <sc-memory/sc_agent_context.hpp>

namespace dm
{
class CommonUtils
{
public:
  static void SetErrorMessage(ScAgentContext * context, ScAddr const & actionAddr, std::string const & errorMessage);
};

}  // namespace dm
