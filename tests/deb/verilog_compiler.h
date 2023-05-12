// Copyright 2022 Nathan Prat

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#pragma once

#include <string>

namespace yosys::testing
{

/**
 * Helper class to compile a .v into a .blif
 */
namespace VerilogHelper
{

/**
 * .v -> .blif; with yosys
 *
 * IMPORTANT: Yosys:: as no concept of exception or error code, it will simply
 * exit/abort in case of error
 *
 * @param inputs_v_full_paths paths to the (several) Verilog .v to process
 * @param output_blif_full_path path to the output .blif
 */
void CompileVerilog(const std::string &inputs_v_full_path, const std::string &output_blif_full_path);

} // namespace VerilogHelper

} // namespace yosys::testing
