#pragma once

#include <sc-memory/sc_agent.hpp>

namespace dm
{
class LoginUserAgent : public ScActionInitiatedAgent
{
public:
  ScAddr GetActionClass() const override;

  ScResult DoProgram(ScAction & action) override;

private:
  std::string ValidateUsername(ScAddr const & usernameAddr) const;
  std::string ValidatePassword(ScAddr const & passwordAddr) const;
};
}  // namespace dm
