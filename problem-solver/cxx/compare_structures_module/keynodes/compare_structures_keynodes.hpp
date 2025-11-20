#pragma once
#include <sc-memory/sc_keynodes.hpp>

namespace dm
{
class CompareStructuresKeynodes : public ScKeynodes
{
public:
  static inline ScKeynode const action_compare_structures{"action_compare_structures", ScType::ConstNodeClass};

  static inline ScKeynode const concept_difference{"concept_difference", ScType::ConstNodeClass};

  static inline ScKeynode const concept_forward_difference{"concept_forward_difference", ScType::ConstNodeClass};

  static inline ScKeynode const concept_reverse_difference{"concept_reverse_difference", ScType::ConstNodeClass};
};
}  // namespace dm
