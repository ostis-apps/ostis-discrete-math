#include "compare_structures_agent.hpp"

#include "keynodes/compare_structures_keynodes.hpp"

namespace dm
{

ScAddr CompareStructuresAgent::GetActionClass() const
{
  return CompareStructuresKeynodes::action_compare_structures;
}

ScAddrUnorderedSet CompareStructuresAgent::FormSet(ScAddr const & structure, ScType type)
{
  ScAddrUnorderedSet elements;
  ScTemplate templ;
  templ.Triple(
    structure,
    ScType::VarPermPosArc,
    type >> "_element"
  );
  ScTemplateSearchResult templResult;
  m_context.SearchByTemplate(templ, templResult);
  for (size_t i = 0; i < templResult.Size(); i++) {
    ScTemplateResultItem element = templResult[i];
    ScAddr const & elementAddr = element["_element"];
    elements.insert(elementAddr);
  }
  return elements;
}

void CompareStructuresAgent::AddNodesToStruct(ScAddrUnorderedSet const & nodes1, ScAddrUnorderedSet const & nodes2, ScAddr const & resultStructure)
{
  for (const auto& node : nodes1) 
    if (nodes2.find(node) == nodes2.end()) 
      m_context.GenerateConnector(ScType::ConstPermPosArc, resultStructure, node);
}

void CompareStructuresAgent::AddConnectorsToStruct(ScAddrUnorderedSet const & cons1, ScAddrUnorderedSet const & cons2, ScAddr const & resultStructure)
{
  for (const auto& con1 : cons1) {
    bool found = 0;
    for (const auto& con2: cons2)
      if (AreConnectorsEqual(con1, con2)) {
        found = 1;
        break;
      }
    if (!found)
      m_context.GenerateConnector(ScType::ConstPermPosArc, resultStructure, con1);
  }
}

bool CompareStructuresAgent::AreConnectorsEqual(ScAddr const & con1, ScAddr const & con2)
{
  if (con1 == con2) 
    return true;
  ScType con1Type = m_context.GetElementType(con1);
  ScType con2Type = m_context.GetElementType(con2);
  if (con1Type != con2Type) 
    return false;
  ScAddr const & source1 = m_context.GetArcSourceElement(con1);
  ScAddr const & target1 = m_context.GetArcTargetElement(con1);
  ScAddr const & source2 = m_context.GetArcSourceElement(con2);
  ScAddr const & target2 = m_context.GetArcTargetElement(con2);
  return (source1 == source2) && (target1 == target2);
}

ScResult CompareStructuresAgent::DoProgram(ScAction & action)
{
  ScAddr const & struct1Addr = action.GetArgument(ScKeynodes::rrel_1);
  ScAddr const & struct2Addr = action.GetArgument(ScKeynodes::rrel_2);
  if (!m_context.IsElement(struct1Addr) or !m_context.IsElement(struct2Addr)) {
    m_logger.Warning("Action does not have one of arguments(or all).");
    return action.FinishWithError();
  }
  
  ScAddr const & structWithExtraElementsAddr = m_context.GenerateNode(ScType::ConstNodeStructure);
  ScAddr const & structWithMissingElementsAddr = m_context.GenerateNode(ScType::ConstNodeStructure);
  
  ScAddrUnorderedSet nodes1 = FormSet(struct1Addr, ScType::VarNode);
  ScAddrUnorderedSet nodes2 = FormSet(struct2Addr, ScType::VarNode);

  AddNodesToStruct(nodes1, nodes2, structWithExtraElementsAddr);
  AddNodesToStruct(nodes2, nodes1, structWithMissingElementsAddr);

  ScAddrUnorderedSet connectors1 = FormSet(struct1Addr, ScType::VarConnector);
  ScAddrUnorderedSet connectors2 = FormSet(struct2Addr, ScType::VarConnector);

  AddConnectorsToStruct(connectors1, connectors2, structWithExtraElementsAddr);
  AddConnectorsToStruct(connectors2, connectors1, structWithMissingElementsAddr);
 
  ScAddr const & tupleAddr = m_context.GenerateNode(ScType::ConstNodeTuple);

  ScAddr const & conceptDifferenceAddr = m_context.SearchElementBySystemIdentifier(CompareStructuresKeynodes::concept_difference);
  ScAddr const & conceptForwardDifferenceAddr = m_context.SearchElementBySystemIdentifier(CompareStructuresKeynodes::concept_forward_difference);
  ScAddr const & conceptReverseDifferenceAddr = m_context.SearchElementBySystemIdentifier(CompareStructuresKeynodes::concept_reverse_difference);

  ScAddr const & arc1 = m_context.GenerateConnector(ScType::ConstPermPosArc, conceptDifferenceAddr, tupleAddr);
  ScAddr const & arc2 = m_context.GenerateConnector(ScType::ConstPermPosArc, conceptForwardDifferenceAddr, structWithMissingElementsAddr);
  ScAddr const & arc3 = m_context.GenerateConnector(ScType::ConstPermPosArc, conceptReverseDifferenceAddr, structWithExtraElementsAddr);
  ScAddr const & arc4 = m_context.GenerateConnector(ScType::ConstPermPosArc, tupleAddr, structWithMissingElementsAddr);
  ScAddr const & arc5 = m_context.GenerateConnector(ScType::ConstPermPosArc, tupleAddr, structWithExtraElementsAddr);
  
  action.FormResult(conceptDifferenceAddr, arc1, tupleAddr, conceptForwardDifferenceAddr, arc2, structWithMissingElementsAddr, conceptReverseDifferenceAddr, arc3, structWithMissingElementsAddr, arc4, arc5);
  return action.FinishSuccessfully();  
}

}  // namespace dm
