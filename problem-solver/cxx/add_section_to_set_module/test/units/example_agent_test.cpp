#include <sc-memory/test/sc_test.hpp>

#include "agent/example_agent.hpp"
#include "keynodes/example_keynodes.hpp"

namespace exampleTest
{

using ExampleModuleTest = ScMemoryTest;

TEST_F(ExampleModuleTest, ExampleAgentTest)
{
  ScAgentContext & context = *m_ctx;
  context.SubscribeAgent<dm::ExampleAgent>();
  ScAction testAction = context.GenerateAction(dm::ExampleKeynodes::action_example);
  EXPECT_TRUE(testAction.InitiateAndWait());
  EXPECT_TRUE(testAction.IsFinishedSuccessfully());
  context.UnsubscribeAgent<dm::ExampleAgent>();
}

}  // namespace exampleTest
