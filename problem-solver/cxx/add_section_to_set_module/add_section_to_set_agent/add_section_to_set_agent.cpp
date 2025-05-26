#include "add_section_to_set_agent.hpp"

#include "keynodes/add_section_to_set_keynodes.hpp"

namespace dm
{

ScAddr AddSectionToSetAgent::GetActionClass() const
{
  return AddSectionToSetKeynodes::action_add_section_to_set;
}

bool AddSectionToSetAgent::IsSectionInSetOfCompletedSections(ScAddr const & set, ScAddr const & section)
{
  return m_context.CheckConnector(set, section, ScType::ConstPermPosArc);
}

ScResult AddSectionToSetAgent::DoProgram(ScAction & action)
{
  ScAddr const & userAddr = action.GetArgument(ScKeynodes::rrel_1); //пользователь
  ScAddr const & sectionAddr = action.GetArgument(ScKeynodes::rrel_2); //прочитанный раздел
  if (!m_context.IsElement(userAddr) or !m_context.IsElement(sectionAddr)) {
    m_logger.Warning("Action does not have one of arguments(or all)."); 
    return action.FinishWithError();
  }
  ScTemplate templ1;
  templ1.Quintuple(
    userAddr,
    ScType::VarCommonArc,
    ScType::VarNodeTuple >> "_set_of_completed_sections",
    ScType::VarPermPosArc,
    AddSectionToSetKeynodes::nrel_completed_sections
  );
  ScTemplateSearchResult result;
  m_context.SearchByTemplate(templ1, result);
  ScAddr setOfCompletedSectionsAddr;
  if (result.Size() != 0) { //множество есть
    ScTemplateResultItem item = result[0];
    setOfCompletedSectionsAddr = item["_set_of_completed_sections"];
  }
  else {  //множества нет
    ScAddr const & nodeAddr = m_context.GenerateNode(ScType::ConstNodeTuple);
    setOfCompletedSectionsAddr = nodeAddr;
    ScAddr const & arcAddr1 = m_context.GenerateConnector(ScType::ConstCommonArc, userAddr, setOfCompletedSectionsAddr);
    ScAddr const & nodeAddr = AddSectionToSetKeynodes::nrel_completed_sections;
    ScAddr const & arcAddr2 = m_context.GenerateConnector(ScType::ConstPermPosArc, nodeAddr, arcAddr1);
  }
  if (IsSectionInSetOfCompletedSections(setOfCompletedSectionsAddr, sectionAddr) == false) {
    ScAddr const & arcAddr = m_context.GenerateConnector(ScType::ConstPermPosArc, setOfCompletedSectionsAddr, sectionAddr);
    action.FormResult(setOfCompletedSectionsAddr, arcAddr, sectionAddr);
    return action.FinishSuccessfully();  
  }
  else
    return action.FinishSuccessfully();
}
}  // namespace dm  