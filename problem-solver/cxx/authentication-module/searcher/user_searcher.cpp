#include "user_searcher.hpp"

#include "keynodes/authentication_keynodes.hpp"

using namespace dm;

UserSearcher::UserSearcher(ScMemoryContext * context)
  : m_context(context)
{
}

ScAddr UserSearcher::GetUser(std::string const & username) const
{
  auto const & links = m_context->SearchLinksByContent(username);
  for (auto const & linkAddr : links)
  {
    auto const & userIterator = m_context->CreateIterator5(
        ScType::ConstNode,
        ScType::ConstCommonArc,
        linkAddr,
        ScType::ConstPermPosArc,
        AuthenticationKeynodes::nrel_username);
    while (userIterator->Next())
    {
      ScAddr const & userAddr = userIterator->Get(0);
      if (m_context->CheckConnector(AuthenticationKeynodes::concept_user, userAddr, ScType::ConstPermPosArc))
        return userAddr;
    }
  }
  return ScAddr::Empty;
}