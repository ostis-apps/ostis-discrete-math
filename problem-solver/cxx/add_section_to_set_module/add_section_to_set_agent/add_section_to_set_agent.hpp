#pragma once

#include <sc-memory/sc_agent.hpp>

namespace dm
{
class AddSectionToSetAgent : public ScActionInitiatedAgent
{
public:
  ScAddr GetActionClass() const override;

  bool IsSectionInSetOfCompletedSections(ScAddr const & set, ScAddr const & section);

  ScResult DoProgram(ScAction & action) override;
};
}  // namespace dm
