#include "add_section_to_set_module.hpp"

#include "add_section_to_set_agent/add_section_to_set_agent.hpp"

namespace dm
{
SC_MODULE_REGISTER(AddSectionToSetModule)->Agent<AddSectionToSetAgent>();
}  // namespace dm
