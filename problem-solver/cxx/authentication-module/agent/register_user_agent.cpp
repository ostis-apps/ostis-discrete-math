#include "register_user_agent.hpp"

#include "keynodes/authentication_keynodes.hpp"

#include "searcher/user_searcher.hpp"

#include "utils/authentication_utils.hpp"

#include "utils/common_utils.hpp"

namespace dm
{

ScAddr RegisterUserAgent::GetActionClass() const
{
  return AuthenticationKeynodes::action_register_user;
}

ScResult RegisterUserAgent::DoProgram(ScAction & action)
{
  auto const & [usernameAddr, passwordAddr] = action.GetArguments<2>();
  try
  {
    auto const & usernameContent = AuthenticationUtils::CheckUsername(&m_context, usernameAddr);
    auto const & passwordContent = AuthenticationUtils::CheckPassword(&m_context, passwordAddr);
    auto const & hashedPassword = AuthenticationUtils::HashPassword(passwordContent);

    UserSearcher userSearcher(&m_context);

    ScAddr const & existingUserAddr = userSearcher.GetUser(usernameContent);
    if (existingUserAddr.IsValid())
    {
      CommonUtils::SetErrorMessage(&m_context, action, "User " + usernameContent + " already exists.");
      return action.FinishWithError();
    }

    ScAddr const & userAddr = m_context.GenerateNode(ScType::ConstNode);
    m_context.GenerateConnector(ScType::ConstPermPosArc, AuthenticationKeynodes::concept_user, userAddr);

    ScAddr const & userToUsernameArc = m_context.GenerateConnector(ScType::ConstCommonArc, userAddr, usernameAddr);
    m_context.GenerateConnector(ScType::ConstPermPosArc, AuthenticationKeynodes::nrel_username, userToUsernameArc);

    ScAddr const & passwordLink = m_context.GenerateLink(ScType::ConstNodeLink);
    m_context.SetLinkContent(passwordLink, hashedPassword);
    ScAddr const & userToPasswordArc = m_context.GenerateConnector(ScType::ConstCommonArc, userAddr, passwordLink);
    m_context.GenerateConnector(
        ScType::ConstPermPosArc, AuthenticationKeynodes::nrel_hashed_password, userToPasswordArc);

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
