#pragma once

#include <sc-memory/sc_agent.hpp>

namespace dm
{
class CompareStructuresAgent : public ScActionInitiatedAgent
{
public:
  ScAddr GetActionClass() const override;

  ScAddrUnorderedSet FormSet(ScAddr const & structure, ScType type);

  void AddNodesToStruct(ScAddrUnorderedSet const & nodes1, ScAddrUnorderedSet const & nodes2, ScAddr const & resultStructure);

  void AddConnectorsToStruct(ScAddrUnorderedSet const & cons1, ScAddrUnorderedSet const & cons2, ScAddr const & resultStructure);

  bool AreConnectorsEqual(ScAddr const & con1, ScAddr const & con2);

  ScResult DoProgram(ScAction & action) override;
};
}  // namespace dm
