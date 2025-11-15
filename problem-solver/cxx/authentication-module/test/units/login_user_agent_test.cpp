#include <sc-memory/test/sc_test.hpp>
#include <sc-builder/scs_loader.hpp>

#include "agent/login_user_agent.hpp"
#include "keynodes/authentication_keynodes.hpp"

namespace exampleTest
{

std::string const TEST_FILES_DIR_PATH = "../test-structures/login-user-agent/";

using LoginUserAgentTest = ScMemoryTest;

TEST_F(LoginUserAgentTest, LoginTest)
{
  ScAgentContext & context = *m_ctx;

  ScsLoader loader;
  loader.loadScsFile(context, TEST_FILES_DIR_PATH + "user_with_password.scs");

  context.SubscribeAgent<dm::LoginUserAgent>();
  ScAddr const & testActionAddr = context.SearchElementBySystemIdentifier("test_action");
  EXPECT_TRUE(context.IsElement(testActionAddr));
  ScAction testAction = context.ConvertToAction(testActionAddr);
  EXPECT_TRUE(testAction.InitiateAndWait());
  EXPECT_TRUE(testAction.IsFinishedSuccessfully());

  ScStructure const & result = testAction.GetResult();

  ScAddr const & testUserAddr = context.SearchElementBySystemIdentifier("test_user_1");
  EXPECT_TRUE(context.IsElement(testUserAddr));
  EXPECT_FALSE(result.IsEmpty());
  EXPECT_TRUE(result.HasElement(testUserAddr));

  context.UnsubscribeAgent<dm::LoginUserAgent>();
}

TEST_F(LoginUserAgentTest, LoginWithoutUserPasswordTest)
{
  ScAgentContext & context = *m_ctx;

  ScsLoader loader;
  loader.loadScsFile(context, TEST_FILES_DIR_PATH + "user_without_password.scs");

  context.SubscribeAgent<dm::LoginUserAgent>();
  ScAddr const & testActionAddr = context.SearchElementBySystemIdentifier("test_action");
  EXPECT_TRUE(context.IsElement(testActionAddr));
  ScAction testAction = context.ConvertToAction(testActionAddr);
  EXPECT_TRUE(testAction.InitiateAndWait());
  EXPECT_TRUE(testAction.IsFinishedWithError());
  context.UnsubscribeAgent<dm::LoginUserAgent>();
}

TEST_F(LoginUserAgentTest, LoginWithWrongPasswordTest)
{
  ScAgentContext & context = *m_ctx;

  ScsLoader loader;
  loader.loadScsFile(context, TEST_FILES_DIR_PATH + "user_with_wrong_password.scs");

  context.SubscribeAgent<dm::LoginUserAgent>();
  ScAddr const & testActionAddr = context.SearchElementBySystemIdentifier("test_action");
  EXPECT_TRUE(context.IsElement(testActionAddr));
  ScAction testAction = context.ConvertToAction(testActionAddr);
  EXPECT_TRUE(testAction.InitiateAndWait());
  EXPECT_TRUE(testAction.IsFinishedWithError());
  context.UnsubscribeAgent<dm::LoginUserAgent>();
}

TEST_F(LoginUserAgentTest, ActionWithoutPasswordTest)
{
  ScAgentContext & context = *m_ctx;

  ScsLoader loader;
  loader.loadScsFile(context, TEST_FILES_DIR_PATH + "action_without_password.scs");

  context.SubscribeAgent<dm::LoginUserAgent>();
  ScAddr const & testActionAddr = context.SearchElementBySystemIdentifier("test_action");
  EXPECT_TRUE(context.IsElement(testActionAddr));
  ScAction testAction = context.ConvertToAction(testActionAddr);
  EXPECT_TRUE(testAction.InitiateAndWait());
  EXPECT_TRUE(testAction.IsFinishedWithError());
  context.UnsubscribeAgent<dm::LoginUserAgent>();
}

TEST_F(LoginUserAgentTest, ActionWithoutUserTest)
{
  ScAgentContext & context = *m_ctx;

  ScsLoader loader;
  loader.loadScsFile(context, TEST_FILES_DIR_PATH + "action_without_user.scs");

  context.SubscribeAgent<dm::LoginUserAgent>();
  ScAddr const & testActionAddr = context.SearchElementBySystemIdentifier("test_action");
  EXPECT_TRUE(context.IsElement(testActionAddr));
  ScAction testAction = context.ConvertToAction(testActionAddr);
  EXPECT_TRUE(testAction.InitiateAndWait());
  EXPECT_TRUE(testAction.IsFinishedWithError());
  context.UnsubscribeAgent<dm::LoginUserAgent>();
}

}  // namespace exampleTest
