/*
 * Copyright 2017-2018 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the OpenSSL license (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <oqs/oqs.h>

/*
 * Certificate table information. NB: table entries must match SSL_PKEY indices
 */
static const SSL_CERT_LOOKUP ssl_cert_info [] = {
    {EVP_PKEY_RSA, SSL_aRSA}, /* SSL_PKEY_RSA */
    {EVP_PKEY_RSA_PSS, SSL_aRSA}, /* SSL_PKEY_RSA_PSS_SIGN */
    {EVP_PKEY_DSA, SSL_aDSS}, /* SSL_PKEY_DSA_SIGN */
    {EVP_PKEY_EC, SSL_aECDSA}, /* SSL_PKEY_ECC */
    {NID_id_GostR3410_2001, SSL_aGOST01}, /* SSL_PKEY_GOST01 */
    {NID_id_GostR3410_2012_256, SSL_aGOST12}, /* SSL_PKEY_GOST12_256 */
    {NID_id_GostR3410_2012_512, SSL_aGOST12}, /* SSL_PKEY_GOST12_512 */
    {EVP_PKEY_ED25519, SSL_aECDSA}, /* SSL_PKEY_ED25519 */
    {EVP_PKEY_ED448, SSL_aECDSA}, /* SSL_PKEY_ED448 */
#if !defined(OQS_NIST_BRANCH)
///// OQS_TEMPLATE_FRAGMENT_GIVE_SSL_CERT_INFO_START
    {EVP_PKEY_OQSDEFAULT, SSL_aOQSDEFAULT}, /* SSL_PKEY_OQSDEFAULT */
    {EVP_PKEY_P256_OQSDEFAULT, SSL_aP256OQSDEFAULT}, /* SSL_PKEY_P256_OQSDEFAULT */
    {EVP_PKEY_RSA3072_OQSDEFAULT, SSL_aRSA3072OQSDEFAULT}, /* SSL_PKEY_RSA3072_OQSDEFAULT */
    {EVP_PKEY_DILITHIUM2, SSL_aDILITHIUM2}, /* SSL_PKEY_DILITHIUM2 */
    {EVP_PKEY_P256_DILITHIUM2, SSL_aP256DILITHIUM2}, /* SSL_PKEY_P256_DILITHIUM2 */
    {EVP_PKEY_RSA3072_DILITHIUM2, SSL_aRSA3072DILITHIUM2}, /* SSL_PKEY_RSA3072_DILITHIUM2 */
    {EVP_PKEY_DILITHIUM3, SSL_aDILITHIUM3}, /* SSL_PKEY_DILITHIUM3 */
    {EVP_PKEY_DILITHIUM4, SSL_aDILITHIUM4}, /* SSL_PKEY_DILITHIUM4 */
    {EVP_PKEY_P384_DILITHIUM4, SSL_aP384DILITHIUM4}, /* SSL_PKEY_P384_DILITHIUM4 */
    {EVP_PKEY_PICNICL1FS, SSL_aPICNICL1FS}, /* SSL_PKEY_PICNICL1FS */
    {EVP_PKEY_P256_PICNICL1FS, SSL_aP256PICNICL1FS}, /* SSL_PKEY_P256_PICNICL1FS */
    {EVP_PKEY_RSA3072_PICNICL1FS, SSL_aRSA3072PICNICL1FS}, /* SSL_PKEY_RSA3072_PICNICL1FS */
    {EVP_PKEY_QTESLAI, SSL_aQTESLAI}, /* SSL_PKEY_QTESLAI */
    {EVP_PKEY_P256_QTESLAI, SSL_aP256QTESLAI}, /* SSL_PKEY_P256_QTESLAI */
    {EVP_PKEY_RSA3072_QTESLAI, SSL_aRSA3072QTESLAI}, /* SSL_PKEY_RSA3072_QTESLAI */
    {EVP_PKEY_QTESLAIIISIZE, SSL_aQTESLAIIISIZE}, /* SSL_PKEY_QTESLAIIISIZE */
    {EVP_PKEY_P384_QTESLAIIISIZE, SSL_aP384QTESLAIIISIZE}, /* SSL_PKEY_P384_QTESLAIIISIZE */
    {EVP_PKEY_QTESLAIIISPEED, SSL_aQTESLAIIISPEED}, /* SSL_PKEY_QTESLAIIISPEED */
    {EVP_PKEY_P384_QTESLAIIISPEED, SSL_aP384QTESLAIIISPEED}, /* SSL_PKEY_P384_QTESLAIIISPEED */
///// OQS_TEMPLATE_FRAGMENT_GIVE_SSL_CERT_INFO_END
#endif
};
