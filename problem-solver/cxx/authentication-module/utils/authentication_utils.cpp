#include "authentication_utils.hpp"

#include <openssl/sha.h>
#include <iomanip>
#include <sstream>

using namespace dm;

std::string AuthenticationUtils::HashPassword(std::string const & passwordContent)
{
  unsigned char hash[SHA256_DIGEST_LENGTH];
  SHA256_CTX sha256;

  SHA256_Init(&sha256);
  SHA256_Update(&sha256, passwordContent.c_str(), passwordContent.length());
  SHA256_Final(hash, &sha256);

  return bytesToHexString(hash, SHA256_DIGEST_LENGTH);
}

std::string AuthenticationUtils::bytesToHexString(unsigned char const * data, size_t length)
{
  std::stringstream ss;
  for (size_t i = 0; i < length; i++)
  {
    ss << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(data[i]);
  }
  return ss.str();
}

std::string AuthenticationUtils::CheckUsername(ScAgentContext * context, ScAddr const & usernameAddr)
{
  return CheckInput(context, usernameAddr, "Username");
}

std::string AuthenticationUtils::CheckPassword(ScAgentContext * context, ScAddr const & passwordAddr)
{
  return CheckInput(context, passwordAddr, "Password");
}

std::string AuthenticationUtils::CheckInput(
    ScAgentContext * context,
    ScAddr const & inputAddr,
    std::string const & inputName)
{
  if (!context->IsElement(inputAddr))
    SC_THROW_EXCEPTION(utils::ExceptionInvalidParams, inputName + " is not valid.");
  if (!context->GetElementType(inputAddr).IsLink())
    SC_THROW_EXCEPTION(utils::ExceptionInvalidParams, inputName + " is not a link.");
  std::string inputContent;
  context->GetLinkContent(inputAddr, inputContent);
  return inputContent;
}