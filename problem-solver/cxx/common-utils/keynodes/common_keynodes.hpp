#pragma once
#include <sc-memory/sc_keynodes.hpp>

namespace dm
{
class CommonKeynodes : public ScKeynodes
{
public:
  static inline ScKeynode const nrel_error_message{"nrel_error_message", ScType::ConstNodeNonRole};
};
}  // namespace dm
