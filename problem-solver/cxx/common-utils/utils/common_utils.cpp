#include "common_utils.hpp"

#include "keynodes/common_keynodes.hpp"

using namespace dm;

void CommonUtils::SetErrorMessage(ScAgentContext * context, ScAddr const & actionAddr, std::string const & errorMessage)
{
  SC_LOG_ERROR(errorMessage);
  ScAddr const & errorMessageLink = context->GenerateLink(ScType::ConstNodeLink);
  context->SetLinkContent(errorMessageLink, errorMessage);
  ScAddr const & errorMessageArc = context->GenerateConnector(ScType::ConstCommonArc, actionAddr, errorMessageLink);
  context->GenerateConnector(ScType::ConstPermPosArc, CommonKeynodes::nrel_error_message, errorMessageArc);
}