#include "compare_structures_module.hpp"

#include "agent/compare_structures_agent.hpp"

namespace dm
{
SC_MODULE_REGISTER(CompareStructuresModule)->Agent<CompareStructuresAgent>();
}  // namespace dm
