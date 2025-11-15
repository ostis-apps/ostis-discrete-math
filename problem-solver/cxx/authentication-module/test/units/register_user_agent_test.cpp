#include <sc-memory/test/sc_test.hpp>
#include <sc-builder/scs_loader.hpp>

#include "agent/register_user_agent.hpp"
#include "keynodes/authentication_keynodes.hpp"

namespace exampleTest
{

std::string const TEST_FILES_DIR_PATH = "../test-structures/register-user-agent/";

using RegisterUserAgentTest = ScMemoryTest;

TEST_F(RegisterUserAgentTest, RegisterTest)
{
  ScAgentContext & context = *m_ctx;

  ScsLoader loader;
  loader.loadScsFile(context, TEST_FILES_DIR_PATH + "user_with_password.scs");

  context.SubscribeAgent<dm::RegisterUserAgent>();
  ScAddr const & testActionAddr = context.SearchElementBySystemIdentifier("test_action");
  EXPECT_TRUE(context.IsElement(testActionAddr));
  ScAction testAction = context.ConvertToAction(testActionAddr);
  EXPECT_TRUE(testAction.InitiateAndWait());
  EXPECT_TRUE(testAction.IsFinishedSuccessfully());

  ScStructure const & result = testAction.GetResult();

  ScAddr const & testUserAddr = context.SearchElementBySystemIdentifier("test_user_1");
  EXPECT_TRUE(context.IsElement(testUserAddr));
  EXPECT_FALSE(result.IsEmpty());

  auto const & testUserPasswordIterator = context.CreateIterator5(
      testUserAddr,
      ScType::ConstCommonArc,
      ScType::ConstNodeLink,
      ScType::ConstPermPosArc,
      dm::AuthenticationKeynodes::nrel_hashed_password);
  EXPECT_TRUE(testUserPasswordIterator->Next());
  ScAddr const & testUserHashedPasswordLink = testUserPasswordIterator->Get(2);
  std::string testUserHashedPasswordContent;
  context.GetLinkContent(testUserHashedPasswordLink, testUserHashedPasswordContent);

  auto const & resultUserIterator = context.CreateIterator3(result, ScType::ConstPermPosArc, ScType::ConstNode);

  EXPECT_TRUE(resultUserIterator->Next());
  ScAddr const & resultUserAddr = resultUserIterator->Get(2);

  auto const & resultUserPasswordIterator = context.CreateIterator5(
      resultUserAddr,
      ScType::ConstCommonArc,
      ScType::ConstNodeLink,
      ScType::ConstPermPosArc,
      dm::AuthenticationKeynodes::nrel_hashed_password);
  EXPECT_TRUE(resultUserPasswordIterator->Next());
  ScAddr const & resultUserHashedPasswordLink = resultUserPasswordIterator->Get(2);
  std::string resultUserHashedPasswordContent;
  context.GetLinkContent(resultUserHashedPasswordLink, resultUserHashedPasswordContent);
  EXPECT_EQ(resultUserHashedPasswordContent, testUserHashedPasswordContent);
}

TEST_F(RegisterUserAgentTest, ActionWithoutUserTest)
{
  ScAgentContext & context = *m_ctx;

  ScsLoader loader;
  loader.loadScsFile(context, TEST_FILES_DIR_PATH + "action_without_user.scs");

  context.SubscribeAgent<dm::RegisterUserAgent>();
  ScAddr const & testActionAddr = context.SearchElementBySystemIdentifier("test_action");
  EXPECT_TRUE(context.IsElement(testActionAddr));
  ScAction testAction = context.ConvertToAction(testActionAddr);
  EXPECT_TRUE(testAction.InitiateAndWait());
  EXPECT_TRUE(testAction.IsFinishedWithError());
  context.UnsubscribeAgent<dm::RegisterUserAgent>();
}

}  // namespace exampleTest
