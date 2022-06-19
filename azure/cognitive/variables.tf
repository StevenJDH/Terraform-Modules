/*
 * This file is part of Terraform-Modules <https://github.com/StevenJDH/Terraform-Modules>.
 * Copyright (C) 2022 Steven Jenkins De Haro.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "location" {
  description = "Azure location."
  type        = string
}

variable "create_resource_group" {
  description = "Indicates whether or not to create a resource group."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Name of resource group."
  type        = string
}

variable "name" {
  description = "Specifies the name of the Cognitive Service Account. Changing this forces a new resource to be created."
  type        = string
}

variable "kind" {
  description = "Specifies the type of Cognitive Service Account that should be created. You must create your first Face, Text Analytics, or Computer Vision resources from the Azure portal to review and acknowledge the terms and conditions. In Azure Portal, the checkbox to accept terms and conditions is only displayed when a US region is selected."
  type        = string
  validation {
    condition     = contains(["Academic", "AnomalyDetector", "Bing.Autosuggest", "Bing.Autosuggest.v7", "Bing.CustomSearch", "Bing.Search", "Bing.Search.v7", "Bing.Speech", "Bing.SpellCheck", "Bing.SpellCheck.v7", "CognitiveServices", "ComputerVision", "ContentModerator", "CustomSpeech", "CustomVision.Prediction", "CustomVision.Training", "Emotion", "Face,FormRecognizer", "ImmersiveReader", "LUIS", "LUIS.Authoring", "Personalizer", "Recommendations", "SpeakerRecognition", "Speech", "SpeechServices", "SpeechTranslation", "TextAnalytics", "TextTranslation", "WebLM"], var.kind)
    error_message = "Invalid Cognitive Service Account type provided or not supported by module."
  }
}

variable "sku_name" {
  description = "Specifies the SKU Name for this Cognitive Service Account."
  type        = string
  default     = "F0"
  validation {
    condition     = contains(["F0", "F1", "S", "S0", "S1", "S2", "S3", "S4", "S5", "S6", "P0", "P1", "P2"], var.sku_name)
    error_message = "Required SKU name can only be F0, F1, S, S0, S1, S2, S3, S4, S5, S6, P0, P1, or P2."
  }
}

variable "custom_subdomain_name" {
  description = "The subdomain name used for token-based authentication. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "enable_public_or_selected_network_access" {
  description = "Indicates whether or not public or selected network access is allowed for the Cognitive Account. If set to false, private endpoint connections will be the exclusive way to access this resource."
  type        = bool
  default     = true
}

variable "network_acls" {
  description = "Specifies what default action to use when no rules match from ip_rules / virtual_network_rules, and One or more IP Addresses, or CIDR Blocks which should be able to access the Cognitive Account."
  type = object({
    allow_when_no_acl_rules_match = bool,
    ip_rules                      = list(string),
    subnet_id_for_service_rules   = optional(string)
  })
  default     = null
}

variable "create_private_endpoint" {
  description = "Indicates whether or not to create a private endpoint. Required if enable_public_or_selected_network_access is set to false as it will be the exclusive way to access this resource."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}