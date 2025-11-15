#include "login_user_agent.hpp"

#include "keynodes/authentication_keynodes.hpp"

#include "searcher/user_searcher.hpp"

#include "utils/authentication_utils.hpp"

#include "utils/common_utils.hpp"

namespace dm
{

ScAddr LoginUserAgent::GetActionClass() const
{
  return AuthenticationKeynodes::action_login_user;
}

ScResult LoginUserAgent::DoProgram(ScAction & action)
{
  auto const & [usernameAddr, passwordAddr] = action.GetArguments<2>();
  try
  {
    auto const & usernameContent = AuthenticationUtils::CheckUsername(&m_context, usernameAddr);
    auto const & passwordContent = AuthenticationUtils::CheckPassword(&m_context, passwordAddr);
    auto const & hashedPassword = AuthenticationUtils::HashPassword(passwordContent);

    UserSearcher userSearcher(&m_context);

    ScAddr const & userAddr = userSearcher.GetUser(usernameContent);
    if (!userAddr.IsValid())
    {
      CommonUtils::SetErrorMessage(&m_context, action, "User " + usernameContent + " does not exist.");
      return action.FinishWithError();
    }

    auto const & userPasswordIterator = m_context.CreateIterator5(
        userAddr,
        ScType::ConstCommonArc,
        ScType::ConstNodeLink,
        ScType::ConstPermPosArc,
        AuthenticationKeynodes::nrel_hashed_password);
    if (!userPasswordIterator->Next())
    {
      CommonUtils::SetErrorMessage(&m_context, action, "User " + usernameContent + " does not have a password.");
      return action.FinishWithError();
    }
    ScAddr const & userHashedPasswordLink = userPasswordIterator->Get(2);

    if (userPasswordIterator->Next())
    {
      CommonUtils::SetErrorMessage(&m_context, action, "User " + usernameContent + " has more then one password.");
      return action.FinishWithError();
    }

    std::string userHashedPasswordContent;
    m_context.GetLinkContent(userHashedPasswordLink, userHashedPasswordContent);
    if (userHashedPasswordContent != hashedPassword)
    {
      CommonUtils::SetErrorMessage(&m_context, action, "Wrong password for User " + usernameContent + ".");
      return action.FinishWithError();
    }

    action.FormResult(userAddr);

    return action.FinishSuccessfully();
  }
  catch (utils::ScException const & exception)
  {
    m_logger.Error(exception.Description());
    CommonUtils::SetErrorMessage(&m_context, action, exception.Message());
    return action.FinishWithError();
  }
}

}  // namespace dm
