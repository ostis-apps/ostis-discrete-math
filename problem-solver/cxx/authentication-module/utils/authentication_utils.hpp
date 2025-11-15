
#pragma once

#include <string>
#include <sc-memory/sc_agent_context.hpp>

namespace dm
{
class AuthenticationUtils
{
public:
  static std::string HashPassword(std::string const & passwordContent);
  static std::string CheckUsername(ScAgentContext * context, ScAddr const & usernameAddr);
  static std::string CheckPassword(ScAgentContext * context, ScAddr const & passwordAddr);

private:
  static std::string bytesToHexString(unsigned char const * data, size_t length);
  static std::string CheckInput(ScAgentContext * context, ScAddr const & inputAddr, std::string const & inputName);
};

}  // namespace dm
