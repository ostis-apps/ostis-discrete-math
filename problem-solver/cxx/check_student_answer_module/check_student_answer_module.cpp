#include "check_student_answer_module.hpp"

#include "agent/check_student_answer_agent.hpp"

namespace dm
{
SC_MODULE_REGISTER(CheckStudentAnswerModule)->Agent<CheckStudentAnswerAgent>();
}  // namespace dm
