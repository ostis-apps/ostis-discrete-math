#pragma once

#include <sc-memory/sc_memory.hpp>

namespace dm
{
class UserSearcher
{
public:
  explicit UserSearcher(ScMemoryContext * context);

  ScAddr GetUser(std::string const & username) const;

private:
  ScMemoryContext * m_context;
};

}  // namespace dm
