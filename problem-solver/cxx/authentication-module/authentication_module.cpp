#include "authentication_module.hpp"

#include "agent/login_user_agent.hpp"
#include "agent/register_user_agent.hpp"

namespace dm
{
SC_MODULE_REGISTER(AuthenticationModule)->Agent<LoginUserAgent>()->Agent<RegisterUserAgent>();
}  // namespace dm
