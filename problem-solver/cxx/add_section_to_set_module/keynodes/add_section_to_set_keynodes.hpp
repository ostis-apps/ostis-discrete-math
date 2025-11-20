#pragma once
#include <sc-memory/sc_keynodes.hpp>

namespace dm
{
class AddSectionToSetKeynodes : public ScKeynodes
{
public:
  static inline ScKeynode const action_add_section_to_set{"action_add_section_to_set", ScType::ConstNodeClass};

  static inline ScKeynode const nrel_completed_sections{"nrel_completed_sections", ScType::ConstNodeNonRole};
};
}  // namespace dm
