#include "check_student_answer_agent.hpp"

#include "keynodes/check_student_answer_keynodes.hpp"

namespace dm
{

ScAddr CheckStudentAnswerAgent::GetActionClass() const
{
  return CheckStudentAnswerKeynodes::action_check_student_answer;
}

ScResult CheckStudentAnswerAgent::DoProgram(ScAction & action)
{
  ScAddr const & studentAnswerAddr = action.GetArgument(ScKeynodes::rrel_1);
  if (!m_context.IsElement(studentAnswerAddr)) {
    m_logger.Warning("Action does not have one of arguments(or all).");
    return action.FinishWithError();
  }
  ScTemplate templ1;
  templ1.Quintuple(
    action,
    ScType::VarCommonArc,
    ScType::VarNodeStructure >> "_structure",
    ScType::VarPermPosArc,
    CheckStudentAnswerKeynodes::nrel_expected_answer
  );
  ScTemplateSearchResult templ1Result;
  m_context.SearchByTemplate(templ1, templ1Result);
  if (templ1Result.Size() != 1) {
    m_logger.Warning("Action does not have(or more than one) connection with expected answer.");
    return action.FinishWithError();
  }
  ScAddr const & expectedAnswerAddr = templ1Result[0]["_structure"];
  
  ScAction someAction = m_context.GenerateAction(CheckStudentAnswerKeynodes::action_compare_structures);
  ScAddr const & arc1 = m_context.GenerateConnector(ScType::ConstPermPosArc, someAction, studentAnswerAddr);
  m_context.GenerateConnector(ScType::ConstPermPosArc, ScKeynodes::rrel_1, arc1);
  ScAddr const & arc2 = m_context.GenerateConnector(ScType::ConstPermPosArc, someAction, expectedAnswerAddr);
  m_context.GenerateConnector(ScType::ConstPermPosArc, ScKeynodes::rrel_2, arc2);
  if (!someAction.InitiateAndWait(100)) {
    m_logger.Warning("Compare structures action finished unseccessfully.");
    return action.FinishWithError();
  }
  ScStructure const & someActionResult = someAction.GetResult();
  ScAddr const & conceptForwardDifferenceAddr = m_context.SearchElementBySystemIdentifier(CheckStudentAnswerKeynodes::concept_forward_difference);
  
  ScTemplate templ2;
  templ2.Quintuple(
    conceptForwardDifferenceAddr,
    ScType::VarPermPosArc,
    ScType::VarNodeStructure >> "_structure",
    ScType::VarPermPosArc,
    someActionResult
  );
  ScTemplateSearchResult templ2Result;
  m_context.SearchByTemplate(templ2, templ2Result);
  ScStructure const & structWithMissingElementsAddr = m_context.ConvertToStructure(templ2Result[0]["_structure"]);
  if (structWithMissingElementsAddr.IsEmpty()) {
    ScAddr const & linkAddr = m_context.GenerateNode(ScType::ConstNodeLink);
    std::string linkContent = "Student gave right answer";
    m_context.SetLinkContent(linkAddr, linkContent);
    action.FormResult(linkAddr);
    return action.FinishSuccessfully();
  }
  else {
    ScAddr const & conceptStructureWithElementsNotInAnswer = m_context.SearchElementBySystemIdentifier(CheckStudentAnswerKeynodes::concept_structure_with_elements_not_in_answer);
    ScAddr const & arc = m_context.GenerateConnector(ScType::ConstPermPosArc, conceptStructureWithElementsNotInAnswer, structWithMissingElementsAddr);
    action.FormResult(conceptStructureWithElementsNotInAnswer, arc, structWithMissingElementsAddr);
    return action.FinishSuccessfully();
  }
}
}  // namespace dm    
