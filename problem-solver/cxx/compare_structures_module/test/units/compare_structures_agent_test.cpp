#include <sc-memory/test/sc_test.hpp>

#include "agent/compare_structures_agent.hpp"
#include "keynodes/compare_structures_keynodes.hpp"

namespace compareStructuresTest
{

using CompareStructuresModuleTest = ScMemoryTest;

TEST_F(CompareStructuresModuleTest, CompareStructuresAgentTest)
{
  ScAgentContext & context = *m_ctx;
  context.SubscribeAgent<dm::CompareStructuresAgent>();
  ScAction testAction = context.GenerateAction(dm::CompareStructuresKeynodes::action_compare_structures);
  EXPECT_TRUE(testAction.InitiateAndWait());
  EXPECT_TRUE(testAction.IsFinishedSuccessfully());
  context.UnsubscribeAgent<dm::CompareStructuresAgent>();
}

}  // namespace exampleTest
