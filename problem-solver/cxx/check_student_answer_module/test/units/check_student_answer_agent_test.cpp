#include <sc-memory/test/sc_test.hpp>

#include "agent/check_student_answer_agent.hpp"
#include "keynodes/check_student_answer_keynodes.hpp"

namespace exampleTest
{

using CheckStudentAnswerModuleTest = ScMemoryTest;

TEST_F(CheckStudentAnswerModuleTest, CheckStudentAnswerAgentTest)
{
  ScAgentContext & context = *m_ctx;
  context.SubscribeAgent<dm::CheckStudentAnswerAgent>();
  ScAction testAction = context.GenerateAction(dm::CheckStudentAnswerKeynodes::action_check_student_answer);
  EXPECT_TRUE(testAction.InitiateAndWait());
  EXPECT_TRUE(testAction.IsFinishedSuccessfully());
  context.UnsubscribeAgent<dm::CheckStudentAnswerAgent>(); 
}

}  // namespace exampleTest
