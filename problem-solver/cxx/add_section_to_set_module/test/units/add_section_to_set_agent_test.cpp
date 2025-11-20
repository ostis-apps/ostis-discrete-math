#include <sc-memory/test/sc_test.hpp>

#include "agent/add_section_to_set_agent.hpp"
#include "keynodes/add_section_to_set_keynodes.hpp"

namespace exampleTest
{

using ExampleModuleTest = ScMemoryTest;

TEST_F(ExampleModuleTest, ExampleAgentTest)
{
  ScAgentContext & context = *m_ctx;
  context.SubscribeAgent<dm::AddSectionToSetAgent>();
  ScAction testAction = context.GenerateAction(dm::AddSectionToSetKeynodes::action_add_section_to_set);
  EXPECT_TRUE(testAction.InitiateAndWait());
  EXPECT_TRUE(testAction.IsFinishedSuccessfully());
  context.UnsubscribeAgent<dm::AddSectionToSetAgent>(); 
}

}  // namespace exampleTest
