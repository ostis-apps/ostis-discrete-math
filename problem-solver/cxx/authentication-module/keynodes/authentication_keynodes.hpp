#pragma once
#include <sc-memory/sc_keynodes.hpp>

namespace dm
{
class AuthenticationKeynodes : public ScKeynodes
{
public:
  static inline ScKeynode const action_login_user{"action_login_user", ScType::ConstNodeClass};
  static inline ScKeynode const action_register_user{"action_register_user", ScType::ConstNodeClass};
  static inline ScKeynode const concept_user{"concept_user", ScType::ConstNodeClass};

  static inline ScKeynode const nrel_username{"nrel_username", ScType::ConstNodeNonRole};
  static inline ScKeynode const nrel_hashed_password{"nrel_hashed_password", ScType::ConstNodeNonRole};
};
}  // namespace dm
