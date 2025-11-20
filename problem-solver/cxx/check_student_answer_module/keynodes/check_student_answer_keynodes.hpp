#pragma once
#include <sc-memory/sc_keynodes.hpp>

namespace dm
{
class CheckStudentAnswerKeynodes : public ScKeynodes
{
public:
  static inline ScKeynode const action_check_student_answer{"action_check_student_answer", ScType::ConstNodeClass};

  static inline ScKeynode const nrel_expected_answer{"nrel_expected_answer", ScType::ConstNodeNonRole};

  static inline ScKeynode const action_compare_structures{"action_compare_structures", ScType::ConstNodeClass};

  static inline ScKeynode const concept_forward_difference{"concept_forward_difference", ScType::ConstNodeClass};

  static inline ScKeynode const concept_structure_with_elements_not_in_answer{"concept_structure_with_elements_not_in_answer", ScType::ConstNodeClass};
};
}  // namespace dm
