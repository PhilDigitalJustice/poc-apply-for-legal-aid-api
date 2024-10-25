-- V1__create_active_storage_attachments.sql

-- Enable necessary extensions

CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "plpgsql";


-- Create the active_storage_attachments table
CREATE TABLE IF NOT EXISTS active_storage_attachments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR NOT NULL,
    record_id UUID NOT NULL,
    record_type VARCHAR NOT NULL,
    blob_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL,
    CONSTRAINT index_active_storage_attachments_uniqueness UNIQUE (record_type, record_id, name, blob_id)
);

-- Create the active_storage_blobs table
CREATE TABLE IF NOT EXISTS active_storage_blobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key VARCHAR NOT NULL,
    filename VARCHAR NOT NULL,
    content_type VARCHAR,
    metadata TEXT,
    byte_size BIGINT NOT NULL,
    checksum VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL,
    service_name VARCHAR NOT NULL,
    CONSTRAINT index_active_storage_blobs_on_key UNIQUE (key)
);

-- Create the active_storage_variant_records table
CREATE TABLE IF NOT EXISTS active_storage_variant_records (
    id SERIAL PRIMARY KEY,
    blob_id UUID NOT NULL,
    variation_digest VARCHAR NOT NULL,
    CONSTRAINT index_active_storage_variant_records_uniqueness UNIQUE (blob_id, variation_digest)
);

ALTER TABLE active_storage_attachments
    ADD CONSTRAINT fk_active_storage_attachments_blob_id
        FOREIGN KEY (blob_id) REFERENCES active_storage_blobs(id) ON DELETE CASCADE;

ALTER TABLE active_storage_variant_records
    ADD CONSTRAINT fk_active_storage_variant_records_blob_id
        FOREIGN KEY (blob_id) REFERENCES active_storage_blobs(id) ON DELETE CASCADE;

-- Create the actor_permissions table
CREATE TABLE IF NOT EXISTS actor_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    permittable_type VARCHAR,
    permittable_id UUID,
    permission_id UUID,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT actor_permissions_uniqueness UNIQUE (permittable_type, permittable_id, permission_id)
);

CREATE INDEX index_actor_permissions_on_permittable_type_and_permittable_id
    ON actor_permissions (permittable_type, permittable_id);

-- Create the addresses table
CREATE TABLE IF NOT EXISTS addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    address_line_one VARCHAR,
    address_line_two VARCHAR,
    city VARCHAR,
    county VARCHAR,
    postcode VARCHAR,
    applicant_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    organisation VARCHAR,
    lookup_used BOOLEAN DEFAULT FALSE NOT NULL,
    lookup_id VARCHAR,
    building_number_name VARCHAR,
    location VARCHAR,
    country_code VARCHAR,
    country_name VARCHAR,
    care_of VARCHAR,
    care_of_first_name VARCHAR,
    care_of_last_name VARCHAR,
    care_of_organisation_name VARCHAR,
    address_line_three VARCHAR
);

CREATE INDEX index_addresses_on_applicant_id ON addresses (applicant_id);

-- Create the admin_reports table
CREATE TABLE IF NOT EXISTS admin_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create the admin_users table
CREATE TABLE IF NOT EXISTS admin_users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR DEFAULT '' NOT NULL,
    email VARCHAR DEFAULT '' NOT NULL,
    encrypted_password VARCHAR DEFAULT '' NOT NULL,
    sign_in_count INTEGER DEFAULT 0 NOT NULL,
    current_sign_in_at TIMESTAMP,
    last_sign_in_at TIMESTAMP,
    current_sign_in_ip INET,
    last_sign_in_ip INET,
    failed_attempts INTEGER DEFAULT 0 NOT NULL,
    locked_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create the allegations table
CREATE TABLE IF NOT EXISTS allegations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    denies_all BOOLEAN,
    additional_information VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_allegations_on_legal_aid_application_id ON allegations (legal_aid_application_id);

-- Create the applicants table
CREATE TABLE IF NOT EXISTS applicants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR,
    date_of_birth DATE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    last_name VARCHAR,
    email VARCHAR,
    national_insurance_number VARCHAR,
    confirmation_token VARCHAR,
    confirmed_at TIMESTAMP,
    confirmation_sent_at TIMESTAMP,
    failed_attempts INTEGER DEFAULT 0 NOT NULL,
    unlock_token VARCHAR,
    locked_at TIMESTAMP,
    employed BOOLEAN,
    remember_created_at TIMESTAMP,
    remember_token VARCHAR,
    self_employed BOOLEAN DEFAULT FALSE,
    armed_forces BOOLEAN DEFAULT FALSE,
    has_national_insurance_number BOOLEAN,
    age_for_means_test_purposes INTEGER,
    encrypted_true_layer_token JSONB,
    has_partner BOOLEAN,
    receives_state_benefits BOOLEAN,
    partner_has_contrary_interest BOOLEAN,
    student_finance BOOLEAN,
    student_finance_amount DECIMAL,
    extra_employment_information BOOLEAN,
    extra_employment_information_details VARCHAR,
    last_name_at_birth VARCHAR,
    changed_last_name BOOLEAN,
    same_correspondence_and_home_address BOOLEAN,
    no_fixed_residence BOOLEAN,
    correspondence_address_choice VARCHAR,
    shared_benefit_with_partner BOOLEAN,
    applied_previously BOOLEAN,
    previous_reference VARCHAR
);

CREATE UNIQUE INDEX index_applicants_on_confirmation_token ON applicants (confirmation_token);
CREATE INDEX index_applicants_on_email ON applicants (email);
CREATE UNIQUE INDEX index_applicants_on_unlock_token ON applicants (unlock_token);

-- Create the application_digests table
CREATE TABLE IF NOT EXISTS application_digests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    firm_name VARCHAR NOT NULL,
    provider_username VARCHAR NOT NULL,
    date_started DATE NOT NULL,
    date_submitted DATE,
    days_to_submission INTEGER,
    use_ccms BOOLEAN DEFAULT FALSE,
    matter_types VARCHAR NOT NULL,
    proceedings VARCHAR NOT NULL,
    passported BOOLEAN DEFAULT FALSE,
    df_used BOOLEAN DEFAULT FALSE,
    earliest_df_date DATE,
    df_reported_date DATE,
    working_days_to_report_df INTEGER,
    working_days_to_submit_df INTEGER,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    employed BOOLEAN DEFAULT FALSE NOT NULL,
    hmrc_data_used BOOLEAN DEFAULT FALSE NOT NULL,
    referred_to_caseworker BOOLEAN DEFAULT FALSE NOT NULL,
    true_layer_path BOOLEAN,
    bank_statements_path BOOLEAN,
    true_layer_data BOOLEAN,
    has_partner BOOLEAN,
    contrary_interest BOOLEAN,
    partner_dwp_challenge BOOLEAN,
    applicant_age INTEGER,
    non_means_tested BOOLEAN,
    family_linked BOOLEAN,
    family_linked_lead_or_associated VARCHAR,
    number_of_family_linked_applications INTEGER,
    legal_linked BOOLEAN,
    legal_linked_lead_or_associated VARCHAR,
    number_of_legal_linked_applications INTEGER,
    no_fixed_address BOOLEAN,
    CONSTRAINT index_application_digests_on_legal_aid_application_id UNIQUE (legal_aid_application_id)
);

-- Create the attachments table
CREATE TABLE IF NOT EXISTS attachments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID,
    attachment_type VARCHAR,
    pdf_attachment_id UUID,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    attachment_name VARCHAR,
    original_filename TEXT
);

-- Create the attempts_to_settles table
CREATE TABLE IF NOT EXISTS attempts_to_settles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attempts_made TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    proceeding_id UUID NOT NULL
);

CREATE INDEX index_attempts_to_settles_on_proceeding_id ON attempts_to_settles (proceeding_id);

-- Create the bank_account_holders table
CREATE TABLE IF NOT EXISTS bank_account_holders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bank_provider_id UUID NOT NULL,
    true_layer_response JSON,
    full_name VARCHAR,
    addresses JSON,
    date_of_birth DATE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_bank_account_holders_on_bank_provider_id ON bank_account_holders (bank_provider_id);

-- Create the bank_accounts table
CREATE TABLE IF NOT EXISTS bank_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bank_provider_id UUID NOT NULL,
    true_layer_response JSON,
    true_layer_balance_response JSON,
    true_layer_id VARCHAR,
    name VARCHAR,
    currency VARCHAR,
    account_number VARCHAR,
    sort_code VARCHAR,
    balance DECIMAL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    account_type VARCHAR
);

CREATE INDEX index_bank_accounts_on_bank_provider_id ON bank_accounts (bank_provider_id);

-- Create the bank_errors table
CREATE TABLE IF NOT EXISTS bank_errors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    applicant_id UUID NOT NULL,
    bank_name VARCHAR,
    error TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_bank_errors_on_applicant_id ON bank_errors (applicant_id);

-- Create the bank_holidays table
CREATE TABLE IF NOT EXISTS bank_holidays (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dates TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create the bank_providers table
CREATE TABLE IF NOT EXISTS bank_providers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    applicant_id UUID NOT NULL,
    true_layer_response JSON,
    credentials_id VARCHAR,
    name VARCHAR,
    true_layer_provider_id VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_bank_providers_on_applicant_id ON bank_providers (applicant_id);
CREATE UNIQUE INDEX index_bank_providers_on_true_layer_provider_id_and_applicant_id
    ON bank_providers (true_layer_provider_id, applicant_id);

-- Create the bank_transactions table
CREATE TABLE IF NOT EXISTS bank_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bank_account_id UUID NOT NULL,
    true_layer_response JSON,
    true_layer_id VARCHAR,
    description VARCHAR,
    amount DECIMAL,
    currency VARCHAR,
    operation VARCHAR,
    merchant VARCHAR,
    happened_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    transaction_type_id UUID,
    meta_data VARCHAR,
    running_balance DECIMAL,
    flags JSON
);

CREATE INDEX index_bank_transactions_on_bank_account_id ON bank_transactions (bank_account_id);
CREATE INDEX index_bank_transactions_on_transaction_type_id ON bank_transactions (transaction_type_id);

-- Create the benefit_check_results table
CREATE TABLE IF NOT EXISTS benefit_check_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    result VARCHAR,
    dwp_ref VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_benefit_check_results_on_legal_aid_application_id ON benefit_check_results (legal_aid_application_id);

-- Create the cash_transactions table
CREATE TABLE IF NOT EXISTS cash_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID,
    amount DECIMAL,
    transaction_date DATE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    month_number INTEGER,
    transaction_type_id UUID,
    owner_type VARCHAR,
    owner_id UUID
);

CREATE UNIQUE INDEX cash_transactions_unique
    ON cash_transactions (legal_aid_application_id, owner_id, transaction_type_id, month_number);
CREATE INDEX index_cash_transactions_on_owner ON cash_transactions (owner_type, owner_id);

-- Create the ccms_opponent_ids table
CREATE TABLE IF NOT EXISTS ccms_opponent_ids (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    serial_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create the ccms_submission_documents table
CREATE TABLE IF NOT EXISTS ccms_submission_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submission_id UUID,
    status VARCHAR,
    document_type VARCHAR,
    ccms_document_id VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    attachment_id UUID
);

-- Create the ccms_submission_histories table
CREATE TABLE IF NOT EXISTS ccms_submission_histories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submission_id UUID NOT NULL,
    from_state VARCHAR,
    to_state VARCHAR,
    success BOOLEAN,
    details TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    request TEXT,
    response TEXT
);

CREATE INDEX index_ccms_submission_histories_on_submission_id
    ON ccms_submission_histories (submission_id);

-- Create the ccms_submissions table
CREATE TABLE IF NOT EXISTS ccms_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID,
    applicant_ccms_reference VARCHAR,
    case_ccms_reference VARCHAR,
    aasm_state VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    applicant_add_transaction_id VARCHAR,
    applicant_poll_count INTEGER DEFAULT 0,
    case_add_transaction_id VARCHAR,
    case_poll_count INTEGER DEFAULT 0
);


CREATE INDEX index_ccms_submissions_on_legal_aid_application_id
    ON ccms_submissions (legal_aid_application_id);

-- Create the cfe_results table
CREATE TABLE IF NOT EXISTS cfe_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID,
    submission_id UUID,
    result TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    type VARCHAR DEFAULT 'CFE::V1::Result'
);

-- Create the cfe_submission_histories table
CREATE TABLE IF NOT EXISTS cfe_submission_histories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submission_id UUID,
    url VARCHAR,
    http_method VARCHAR,
    request_payload TEXT,
    http_response_status INTEGER,
    response_payload TEXT,
    error_message VARCHAR,
    error_backtrace VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create the cfe_submissions table
CREATE TABLE IF NOT EXISTS cfe_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID,
    assessment_id UUID,
    aasm_state VARCHAR,
    error_message VARCHAR,
    cfe_result TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_cfe_submissions_on_legal_aid_application_id
    ON cfe_submissions (legal_aid_application_id);

-- Create the chances_of_successes table
CREATE TABLE IF NOT EXISTS chances_of_successes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    application_purpose TEXT,
    success_prospect VARCHAR,
    success_prospect_details TEXT,
    success_likely BOOLEAN,
    proceeding_id UUID NOT NULL
);

CREATE INDEX index_chances_of_successes_on_proceeding_id
    ON chances_of_successes (proceeding_id);

-- Create the citizen_access_tokens table
CREATE TABLE IF NOT EXISTS citizen_access_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    token VARCHAR DEFAULT '' NOT NULL,
    expires_on DATE NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_citizen_access_tokens_on_legal_aid_application_id
    ON citizen_access_tokens (legal_aid_application_id);

-- Create the debugs table
CREATE TABLE IF NOT EXISTS debugs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    debug_type VARCHAR,
    legal_aid_application_id VARCHAR,
    session_id VARCHAR,
    session TEXT,
    auth_params VARCHAR,
    callback_params VARCHAR,
    callback_url VARCHAR,
    error_details VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    browser_details VARCHAR
);

-- Create the dependants table
CREATE TABLE IF NOT EXISTS dependants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    number INTEGER,
    name VARCHAR,
    date_of_birth DATE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    relationship VARCHAR,
    monthly_income DECIMAL,
    has_income BOOLEAN,
    in_full_time_education BOOLEAN,
    has_assets_more_than_threshold BOOLEAN,
    assets_value DECIMAL
);

CREATE INDEX index_dependants_on_legal_aid_application_id
    ON dependants (legal_aid_application_id);

-- Create the document_categories table
CREATE TABLE IF NOT EXISTS document_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR NOT NULL,
    submit_to_ccms BOOLEAN DEFAULT FALSE NOT NULL,
    ccms_document_type VARCHAR,
    display_on_evidence_upload BOOLEAN DEFAULT FALSE NOT NULL,
    mandatory BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    file_extension VARCHAR,
    description VARCHAR
);

-- Create the domestic_abuse_summaries table
CREATE TABLE IF NOT EXISTS domestic_abuse_summaries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    warning_letter_sent BOOLEAN,
    warning_letter_sent_details TEXT,
    police_notified BOOLEAN,
    police_notified_details TEXT,
    bail_conditions_set BOOLEAN,
    bail_conditions_set_details TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_domestic_abuse_summaries_on_legal_aid_application_id
    ON domestic_abuse_summaries (legal_aid_application_id);

-- Create the dwp_overrides table
CREATE TABLE IF NOT EXISTS dwp_overrides (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    passporting_benefit TEXT,
    has_evidence_of_benefit BOOLEAN,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE UNIQUE INDEX index_dwp_overrides_on_legal_aid_application_id
    ON dwp_overrides (legal_aid_application_id);

-- Create the employment_payments table
CREATE TABLE IF NOT EXISTS employment_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employment_id UUID,
    date DATE NOT NULL,
    gross DECIMAL DEFAULT 0.0 NOT NULL,
    benefits_in_kind DECIMAL DEFAULT 0.0 NOT NULL,
    national_insurance DECIMAL DEFAULT 0.0 NOT NULL,
    tax DECIMAL DEFAULT 0.0 NOT NULL,
    net_employment_income DECIMAL DEFAULT 0.0 NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_employment_payments_on_employment_id
    ON employment_payments (employment_id);

-- Create the employments table
CREATE TABLE IF NOT EXISTS employments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID,
    name VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    owner_type VARCHAR,
    owner_id UUID
);

CREATE INDEX index_employments_on_legal_aid_application_id
    ON employments (legal_aid_application_id);
CREATE INDEX index_employments_on_owner
    ON employments (owner_type, owner_id);

-- V1__create_feedback_final_hearing_firms_gateway_hmrc_tables.sql

-- Create the feedbacks table
CREATE TABLE IF NOT EXISTS feedbacks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    done_all_needed BOOLEAN,
    satisfaction INTEGER,
    improvement_suggestion TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    os VARCHAR,
    browser VARCHAR,
    browser_version VARCHAR,
    source VARCHAR,
    difficulty INTEGER,
    email VARCHAR,
    originating_page VARCHAR,
    legal_aid_application_id UUID
);

-- Create the final_hearings table
CREATE TABLE IF NOT EXISTS final_hearings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proceeding_id UUID NOT NULL,
    work_type INTEGER,
    listed BOOLEAN NOT NULL,
    date DATE,
    details VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE UNIQUE INDEX proceeding_work_type_unique
    ON final_hearings (proceeding_id, work_type);
CREATE INDEX index_final_hearings_on_proceeding_id
    ON final_hearings (proceeding_id);

-- Create the firms table
CREATE TABLE IF NOT EXISTS firms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    ccms_id VARCHAR,
    name VARCHAR
);

-- Create the gateway_evidences table
CREATE TABLE IF NOT EXISTS gateway_evidences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    provider_uploader_id UUID,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_gateway_evidences_on_legal_aid_application_id
    ON gateway_evidences (legal_aid_application_id);
CREATE INDEX index_gateway_evidences_on_provider_uploader_id
    ON gateway_evidences (provider_uploader_id);

-- Create the hmrc_responses table
CREATE TABLE IF NOT EXISTS hmrc_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submission_id VARCHAR,
    use_case VARCHAR,
    response JSON,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    legal_aid_application_id UUID,
    url VARCHAR,
    owner_type VARCHAR,
    owner_id UUID
);

CREATE INDEX index_hmrc_responses_on_legal_aid_application_id
    ON hmrc_responses (legal_aid_application_id);
CREATE INDEX index_hmrc_responses_on_owner
    ON hmrc_responses (owner_type, owner_id);

-- Create the incidents table
CREATE TABLE IF NOT EXISTS incidents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    occurred_on DATE,
    details TEXT,
    legal_aid_application_id UUID,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    told_on DATE
);

CREATE INDEX index_incidents_on_legal_aid_application_id
    ON incidents (legal_aid_application_id);

-- Create the individuals table
CREATE TABLE IF NOT EXISTS individuals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR,
    last_name VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create the involved_children table
CREATE TABLE IF NOT EXISTS involved_children (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    full_name VARCHAR,
    date_of_birth DATE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    ccms_opponent_id INTEGER
);

CREATE INDEX index_involved_children_on_legal_aid_application_id
    ON involved_children (legal_aid_application_id);

-- Create the legal_aid_application_transaction_types table
CREATE TABLE IF NOT EXISTS legal_aid_application_transaction_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID,
    transaction_type_id UUID,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    owner_type VARCHAR,
    owner_id UUID
);

CREATE INDEX laa_trans_type_on_legal_aid_application_id
    ON legal_aid_application_transaction_types (legal_aid_application_id);
CREATE INDEX index_legal_aid_application_transaction_types_on_owner
    ON legal_aid_application_transaction_types (owner_type, owner_id);
CREATE INDEX laa_trans_type_on_transaction_type_id
    ON legal_aid_application_transaction_types (transaction_type_id);

-- Create the legal_aid_applications table
CREATE TABLE IF NOT EXISTS legal_aid_applications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    application_ref VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    applicant_id UUID,
    has_offline_accounts BOOLEAN,
    open_banking_consent BOOLEAN,
    open_banking_consent_choice_at TIMESTAMP,
    own_home VARCHAR,
    property_value DECIMAL(10, 2),
    shared_ownership VARCHAR,
    outstanding_mortgage_amount DECIMAL,
    percentage_home DECIMAL,
    provider_step VARCHAR,
    provider_id UUID,
    draft BOOLEAN,
    transaction_period_start_on DATE,
    transaction_period_finish_on DATE,
    transactions_gathered BOOLEAN,
    completed_at TIMESTAMP,
    declaration_accepted_at TIMESTAMP,
    provider_step_params JSON,
    own_vehicle BOOLEAN,
    substantive_application_deadline_on DATE,
    substantive_application BOOLEAN,
    has_dependants BOOLEAN,
    office_id UUID,
    has_restrictions BOOLEAN,
    restrictions_details VARCHAR,
    no_credit_transaction_types_selected BOOLEAN,
    no_debit_transaction_types_selected BOOLEAN,
    provider_received_citizen_consent BOOLEAN,
    student_finance BOOLEAN,
    discarded_at TIMESTAMP,
    merits_submitted_at TIMESTAMP,
    in_scope_of_laspo BOOLEAN,
    emergency_cost_override BOOLEAN,
    emergency_cost_requested DECIMAL,
    emergency_cost_reasons VARCHAR,
    no_cash_income BOOLEAN,
    no_cash_outgoings BOOLEAN,
    purgeable_on DATE,
    required_document_categories VARCHAR[] DEFAULT '{}' NOT NULL,
    extra_employment_information BOOLEAN,
    extra_employment_information_details VARCHAR,
    full_employment_details VARCHAR,
    client_declaration_confirmed_at TIMESTAMP,
    substantive_cost_override BOOLEAN,
    substantive_cost_requested DECIMAL,
    substantive_cost_reasons VARCHAR,
    applicant_in_receipt_of_housing_benefit BOOLEAN,
    copy_case BOOLEAN,
    copy_case_id UUID,
    case_cloned BOOLEAN,
    separate_representation_required BOOLEAN
);

CREATE INDEX index_legal_aid_applications_on_applicant_id
    ON legal_aid_applications (applicant_id);
CREATE UNIQUE INDEX index_legal_aid_applications_on_application_ref
    ON legal_aid_applications (application_ref);
CREATE INDEX index_legal_aid_applications_on_discarded_at
    ON legal_aid_applications (discarded_at);
CREATE INDEX index_legal_aid_applications_on_office_id
    ON legal_aid_applications (office_id);
CREATE INDEX index_legal_aid_applications_on_provider_id
    ON legal_aid_applications (provider_id);

-- Create the legal_framework_merits_task_lists table
CREATE TABLE IF NOT EXISTS legal_framework_merits_task_lists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID,
    serialized_data TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX idx_lfa_merits_task_lists_on_legal_aid_application_id
    ON legal_framework_merits_task_lists (legal_aid_application_id);

-- Create the legal_framework_submission_histories table
CREATE TABLE IF NOT EXISTS legal_framework_submission_histories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submission_id UUID,
    url VARCHAR,
    http_method VARCHAR,
    request_payload TEXT,
    http_response_status INTEGER,
    response_payload TEXT,
    error_message VARCHAR,
    error_backtrace VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create the legal_framework_submissions table
CREATE TABLE IF NOT EXISTS legal_framework_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID,
    request_id UUID,
    error_message VARCHAR,
    result TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_legal_framework_submissions_on_legal_aid_application_id
    ON legal_framework_submissions (legal_aid_application_id);

-- Create the linked_applications table
CREATE TABLE IF NOT EXISTS linked_applications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lead_application_id UUID,
    associated_application_id UUID NOT NULL,
    link_type_code VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    confirm_link BOOLEAN,
    target_application_id UUID
);

CREATE UNIQUE INDEX index_linked_applications
    ON linked_applications (lead_application_id, associated_application_id);
CREATE INDEX index_linked_applications_on_associated_application_id
    ON linked_applications (associated_application_id);
CREATE INDEX index_linked_applications_on_lead_application_id
    ON linked_applications (lead_application_id);
CREATE INDEX index_linked_applications_on_target_application_id
    ON linked_applications (target_application_id);

-- Create the malware_scan_results table
CREATE TABLE IF NOT EXISTS malware_scan_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    uploader_type VARCHAR,
    uploader_id UUID,
    virus_found BOOLEAN NOT NULL,
    scan_result TEXT,
    file_details JSON,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    scanner_working BOOLEAN
);

CREATE INDEX index_malware_scan_results_on_uploader_type_and_uploader_id
    ON malware_scan_results (uploader_type, uploader_id);

-- Create the matter_oppositions table
CREATE TABLE IF NOT EXISTS matter_oppositions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    reason TEXT DEFAULT '' NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_matter_oppositions_on_legal_aid_application_id
    ON matter_oppositions (legal_aid_application_id);

-- Create the offices table
CREATE TABLE IF NOT EXISTS offices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    ccms_id VARCHAR,
    code VARCHAR,
    firm_id UUID
);

CREATE INDEX index_offices_on_firm_id
    ON offices (firm_id);

-- Create the offices_providers join table without primary key
CREATE TABLE IF NOT EXISTS offices_providers (
    office_id UUID NOT NULL,
    provider_id UUID NOT NULL
);

CREATE INDEX index_offices_providers_on_office_id
    ON offices_providers (office_id);
CREATE INDEX index_offices_providers_on_provider_id
    ON offices_providers (provider_id);

-- Create the opponents table
CREATE TABLE IF NOT EXISTS opponents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    ccms_opponent_id INTEGER,
    opposable_type VARCHAR,
    opposable_id UUID,
    exists_in_ccms BOOLEAN DEFAULT FALSE
);

CREATE INDEX index_opponents_on_legal_aid_application_id
    ON opponents (legal_aid_application_id);
CREATE UNIQUE INDEX index_opponents_on_opposable
    ON opponents (opposable_type, opposable_id);

-- Create the opponents_applications table
CREATE TABLE IF NOT EXISTS opponents_applications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proceeding_id UUID NOT NULL,
    has_opponents_application BOOLEAN,
    reason_for_applying VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_opponents_applications_on_proceeding_id
    ON opponents_applications (proceeding_id);

-- Create the organisations table
CREATE TABLE IF NOT EXISTS organisations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR NOT NULL,
    ccms_type_code VARCHAR NOT NULL,
    ccms_type_text VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create the other_assets_declarations table
CREATE TABLE IF NOT EXISTS other_assets_declarations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    second_home_value DECIMAL,
    second_home_mortgage DECIMAL,
    second_home_percentage DECIMAL,
    timeshare_property_value DECIMAL,
    land_value DECIMAL,
    valuable_items_value DECIMAL,
    inherited_assets_value DECIMAL,
    money_owed_value DECIMAL,
    trust_value DECIMAL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    none_selected BOOLEAN
);

CREATE UNIQUE INDEX index_other_assets_declarations_on_legal_aid_application_id
    ON other_assets_declarations (legal_aid_application_id);

-- Create the parties_mental_capacities table
CREATE TABLE IF NOT EXISTS parties_mental_capacities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    understands_terms_of_court_order BOOLEAN,
    understands_terms_of_court_order_details TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_parties_mental_capacities_on_legal_aid_application_id
    ON parties_mental_capacities (legal_aid_application_id);

-- Create the partners table
CREATE TABLE IF NOT EXISTS partners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR,
    last_name VARCHAR,
    date_of_birth DATE,
    has_national_insurance_number BOOLEAN,
    national_insurance_number VARCHAR,
    legal_aid_application_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    shared_benefit_with_applicant BOOLEAN,
    employed BOOLEAN,
    self_employed BOOLEAN,
    armed_forces BOOLEAN,
    full_employment_details VARCHAR,
    receives_state_benefits BOOLEAN,
    student_finance BOOLEAN,
    student_finance_amount DECIMAL,
    extra_employment_information BOOLEAN,
    extra_employment_information_details VARCHAR,
    no_cash_income BOOLEAN,
    no_cash_outgoings BOOLEAN
);

CREATE INDEX index_partners_on_legal_aid_application_id
    ON partners (legal_aid_application_id);

-- Create the permissions table
CREATE TABLE IF NOT EXISTS permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role VARCHAR,
    description VARCHAR
);

CREATE UNIQUE INDEX index_permissions_on_role
    ON permissions (role);

-- Create the policy_disregards table
CREATE TABLE IF NOT EXISTS policy_disregards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    england_infected_blood_support BOOLEAN,
    vaccine_damage_payments BOOLEAN,
    variant_creutzfeldt_jakob_disease BOOLEAN,
    criminal_injuries_compensation_scheme BOOLEAN,
    national_emergencies_trust BOOLEAN,
    we_love_manchester_emergency_fund BOOLEAN,
    london_emergencies_trust BOOLEAN,
    none_selected BOOLEAN,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    legal_aid_application_id UUID
);

CREATE INDEX index_policy_disregards_on_legal_aid_application_id
    ON policy_disregards (legal_aid_application_id);

-- Create the proceedings table
CREATE TABLE IF NOT EXISTS proceedings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    proceeding_case_id INTEGER,
    lead_proceeding BOOLEAN DEFAULT FALSE NOT NULL,
    ccms_code VARCHAR NOT NULL,
    meaning VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    substantive_cost_limitation DECIMAL NOT NULL,
    delegated_functions_cost_limitation DECIMAL NOT NULL,
    used_delegated_functions_on DATE,
    used_delegated_functions_reported_on DATE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    name VARCHAR NOT NULL,
    matter_type VARCHAR NOT NULL,
    category_of_law VARCHAR NOT NULL,
    category_law_code VARCHAR NOT NULL,
    ccms_matter_code VARCHAR,
    client_involvement_type_ccms_code VARCHAR,
    client_involvement_type_description VARCHAR,
    used_delegated_functions BOOLEAN,
    emergency_level_of_service INTEGER,
    emergency_level_of_service_name VARCHAR,
    emergency_level_of_service_stage INTEGER,
    substantive_level_of_service INTEGER,
    substantive_level_of_service_name VARCHAR,
    substantive_level_of_service_stage INTEGER,
    accepted_emergency_defaults BOOLEAN,
    accepted_substantive_defaults BOOLEAN,
    sca_type VARCHAR,
    relationship_to_child VARCHAR
);

CREATE INDEX index_proceedings_on_legal_aid_application_id
    ON proceedings (legal_aid_application_id);
CREATE UNIQUE INDEX index_proceedings_on_proceeding_case_id
    ON proceedings (proceeding_case_id);

-- Create the proceedings_linked_children table
CREATE TABLE IF NOT EXISTS proceedings_linked_children (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proceeding_id UUID,
    involved_child_id UUID,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE UNIQUE INDEX index_involved_child_proceeding
    ON proceedings_linked_children (involved_child_id, proceeding_id);
CREATE UNIQUE INDEX index_proceeding_involved_child
    ON proceedings_linked_children (proceeding_id, involved_child_id);

-- Create the prohibited_steps table
CREATE TABLE IF NOT EXISTS prohibited_steps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proceeding_id UUID NOT NULL,
    uk_removal BOOLEAN,
    details VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    confirmed_not_change_of_name BOOLEAN
);

CREATE INDEX index_prohibited_steps_on_proceeding_id
    ON prohibited_steps (proceeding_id);

-- Create the providers table
CREATE TABLE IF NOT EXISTS providers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR NOT NULL,
    type VARCHAR,
    roles TEXT,
    sign_in_count INTEGER DEFAULT 0 NOT NULL,
    current_sign_in_at TIMESTAMP,
    last_sign_in_at TIMESTAMP,
    current_sign_in_ip INET,
    last_sign_in_ip INET,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    office_codes TEXT,
    firm_id UUID,
    selected_office_id UUID,
    name VARCHAR,
    email VARCHAR,
    portal_enabled BOOLEAN DEFAULT TRUE,
    contact_id INTEGER,
    invalid_login_details VARCHAR,
    cookies_enabled BOOLEAN,
    cookies_saved_at TIMESTAMP
);

CREATE INDEX index_providers_on_firm_id
    ON providers (firm_id);
CREATE INDEX index_providers_on_selected_office_id
    ON providers (selected_office_id);
CREATE INDEX index_providers_on_type
    ON providers (type);
CREATE UNIQUE INDEX index_providers_on_username
    ON providers (username);

-- Create the regular_transactions table
CREATE TABLE IF NOT EXISTS regular_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    transaction_type_id UUID NOT NULL,
    amount DECIMAL NOT NULL,
    frequency VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    description VARCHAR,
    owner_type VARCHAR,
    owner_id UUID
);

CREATE INDEX index_regular_transactions_on_legal_aid_application_id
    ON regular_transactions (legal_aid_application_id);
CREATE INDEX index_regular_transactions_on_owner
    ON regular_transactions (owner_type, owner_id);
CREATE INDEX index_regular_transactions_on_transaction_type_id
    ON regular_transactions (transaction_type_id);

-- Create the savings_amounts table
CREATE TABLE IF NOT EXISTS savings_amounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    offline_current_accounts DECIMAL,
    cash DECIMAL,
    other_person_account DECIMAL,
    national_savings DECIMAL,
    plc_shares DECIMAL,
    peps_unit_trusts_capital_bonds_gov_stocks DECIMAL,
    life_assurance_endowment_policy DECIMAL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    none_selected BOOLEAN,
    offline_savings_accounts DECIMAL,
    no_account_selected BOOLEAN,
    partner_offline_current_accounts DECIMAL,
    partner_offline_savings_accounts DECIMAL,
    no_partner_account_selected BOOLEAN,
    joint_offline_current_accounts DECIMAL,
    joint_offline_savings_accounts DECIMAL
);

CREATE INDEX index_savings_amounts_on_legal_aid_application_id
    ON savings_amounts (legal_aid_application_id);

-- Create the scheduled_mailings table
CREATE TABLE IF NOT EXISTS scheduled_mailings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID,
    mailer_klass VARCHAR NOT NULL,
    mailer_method VARCHAR NOT NULL,
    arguments VARCHAR NOT NULL,
    scheduled_at TIMESTAMP NOT NULL,
    sent_at TIMESTAMP,
    cancelled_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    status VARCHAR,
    addressee VARCHAR,
    govuk_message_id VARCHAR
);

-- Create the scope_limitations table
CREATE TABLE IF NOT EXISTS scope_limitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proceeding_id UUID NOT NULL,
    scope_type INTEGER,
    code VARCHAR NOT NULL,
    meaning VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    hearing_date DATE,
    limitation_note VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_scope_limitations_on_proceeding_id
    ON scope_limitations (proceeding_id);

-- Create the settings table
CREATE TABLE IF NOT EXISTS settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    mock_true_layer_data BOOLEAN DEFAULT FALSE NOT NULL,
    manually_review_all_cases BOOLEAN DEFAULT TRUE,
    bank_transaction_filename VARCHAR DEFAULT 'db/sample_data/bank_transactions.csv',
    allow_welsh_translation BOOLEAN DEFAULT FALSE NOT NULL,
    enable_ccms_submission BOOLEAN DEFAULT TRUE NOT NULL,
    alert_via_sentry BOOLEAN DEFAULT TRUE NOT NULL,
    digest_extracted_at TIMESTAMP DEFAULT '1970-01-01 00:00:01',
    cfe_compare_run_at TIMESTAMP,
    linked_applications BOOLEAN DEFAULT FALSE NOT NULL,
    collect_hmrc_data BOOLEAN DEFAULT FALSE NOT NULL,
    home_address BOOLEAN DEFAULT FALSE NOT NULL,
    special_childrens_act BOOLEAN DEFAULT FALSE NOT NULL,
    means_test_review_a BOOLEAN DEFAULT FALSE NOT NULL,
    public_law_family BOOLEAN DEFAULT FALSE NOT NULL
);

-- Create the specific_issues table
CREATE TABLE IF NOT EXISTS specific_issues (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proceeding_id UUID NOT NULL,
    confirmed BOOLEAN,
    details VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_specific_issues_on_proceeding_id
    ON specific_issues (proceeding_id);

-- Create the state_machine_proxies table
CREATE TABLE IF NOT EXISTS state_machine_proxies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID,
    type VARCHAR,
    aasm_state VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    ccms_reason VARCHAR
);

-- Create the statement_of_cases table
CREATE TABLE IF NOT EXISTS statement_of_cases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    statement TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    provider_uploader_id UUID
);

CREATE INDEX index_statement_of_cases_on_legal_aid_application_id
    ON statement_of_cases (legal_aid_application_id);
CREATE INDEX index_statement_of_cases_on_provider_uploader_id
    ON statement_of_cases (provider_uploader_id);

-- Create the temp_contract_data table
CREATE TABLE IF NOT EXISTS temp_contract_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    success BOOLEAN,
    office_code VARCHAR,
    response JSON,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create the transaction_types table
CREATE TABLE IF NOT EXISTS transaction_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR,
    operation VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    sort_order INTEGER,
    archived_at TIMESTAMP,
    other_income BOOLEAN DEFAULT FALSE,
    parent_id VARCHAR
);

CREATE INDEX index_transaction_types_on_parent_id
    ON transaction_types (parent_id);

-- Create the true_layer_banks table
CREATE TABLE IF NOT EXISTS true_layer_banks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    banks TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create the undertakings table
CREATE TABLE IF NOT EXISTS undertakings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    offered BOOLEAN,
    additional_information VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_undertakings_on_legal_aid_application_id
    ON undertakings (legal_aid_application_id);

-- V1__create_uploaded_evidence_urgencies_vary_orders_vehicles.sql

-- Create the uploaded_evidence_collections table
CREATE TABLE IF NOT EXISTS uploaded_evidence_collections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    provider_uploader_id UUID,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_uploaded_evidence_collections_on_legal_aid_application_id
    ON uploaded_evidence_collections (legal_aid_application_id);
CREATE INDEX index_uploaded_evidence_collections_on_provider_uploader_id
    ON uploaded_evidence_collections (provider_uploader_id);

-- Create the urgencies table
CREATE TABLE IF NOT EXISTS urgencies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_aid_application_id UUID NOT NULL,
    nature_of_urgency VARCHAR NOT NULL,
    hearing_date_set BOOLEAN,
    hearing_date DATE,
    additional_information VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_urgencies_on_legal_aid_application_id
    ON urgencies (legal_aid_application_id);

-- Create the vary_orders table
CREATE TABLE IF NOT EXISTS vary_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proceeding_id UUID NOT NULL,
    details VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX index_vary_orders_on_proceeding_id
    ON vary_orders (proceeding_id);

-- Create the vehicles table
CREATE TABLE IF NOT EXISTS vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    estimated_value DECIMAL,
    payment_remaining DECIMAL,
    purchased_on DATE,
    used_regularly BOOLEAN,
    legal_aid_application_id UUID,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    more_than_three_years_old BOOLEAN,
    owner VARCHAR
);

CREATE INDEX index_vehicles_on_legal_aid_application_id
    ON vehicles (legal_aid_application_id);

-- Add foreign key constraints
ALTER TABLE active_storage_attachments
    ADD FOREIGN KEY (blob_id) REFERENCES active_storage_blobs(id);
ALTER TABLE active_storage_variant_records
    ADD FOREIGN KEY (blob_id) REFERENCES active_storage_blobs(id);
ALTER TABLE addresses
    ADD FOREIGN KEY (applicant_id) REFERENCES applicants(id);
ALTER TABLE allegations
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE attempts_to_settles
    ADD FOREIGN KEY (proceeding_id) REFERENCES proceedings(id);
ALTER TABLE bank_account_holders
    ADD FOREIGN KEY (bank_provider_id) REFERENCES bank_providers(id);
ALTER TABLE bank_accounts
    ADD FOREIGN KEY (bank_provider_id) REFERENCES bank_providers(id);
ALTER TABLE bank_errors
    ADD FOREIGN KEY (applicant_id) REFERENCES applicants(id);
ALTER TABLE bank_providers
    ADD FOREIGN KEY (applicant_id) REFERENCES applicants(id);
ALTER TABLE bank_transactions
    ADD FOREIGN KEY (bank_account_id) REFERENCES bank_accounts(id);
ALTER TABLE benefit_check_results
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id) ON DELETE CASCADE;
ALTER TABLE ccms_submission_documents
    ADD FOREIGN KEY (submission_id) REFERENCES ccms_submissions(id);
ALTER TABLE ccms_submission_histories
    ADD FOREIGN KEY (submission_id) REFERENCES ccms_submissions(id);
ALTER TABLE ccms_submissions
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id) ON DELETE CASCADE;
ALTER TABLE cfe_submissions
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE chances_of_successes
    ADD FOREIGN KEY (proceeding_id) REFERENCES proceedings(id) ON DELETE CASCADE;
ALTER TABLE citizen_access_tokens
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id) ON DELETE CASCADE;
ALTER TABLE dependants
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE domestic_abuse_summaries
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE dwp_overrides
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE employment_payments
    ADD FOREIGN KEY (employment_id) REFERENCES employments(id);
ALTER TABLE employments
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE final_hearings
    ADD FOREIGN KEY (proceeding_id) REFERENCES proceedings(id);
ALTER TABLE gateway_evidences
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE hmrc_responses
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE involved_children
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE legal_aid_applications
    ADD FOREIGN KEY (applicant_id) REFERENCES applicants(id);
ALTER TABLE legal_aid_applications
    ADD FOREIGN KEY (office_id) REFERENCES offices(id);
ALTER TABLE legal_aid_applications
    ADD FOREIGN KEY (provider_id) REFERENCES providers(id);
ALTER TABLE legal_framework_merits_task_lists
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id) ON DELETE CASCADE;
ALTER TABLE legal_framework_submissions
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE linked_applications
    ADD FOREIGN KEY (associated_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE linked_applications
    ADD FOREIGN KEY (lead_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE matter_oppositions
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id) ON DELETE CASCADE;
ALTER TABLE offices
    ADD FOREIGN KEY (firm_id) REFERENCES firms(id);
ALTER TABLE offices_providers
    ADD FOREIGN KEY (office_id) REFERENCES offices(id);
ALTER TABLE offices_providers
    ADD FOREIGN KEY (provider_id) REFERENCES providers(id);
ALTER TABLE opponents
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE opponents_applications
    ADD FOREIGN KEY (proceeding_id) REFERENCES proceedings(id);
ALTER TABLE parties_mental_capacities
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE partners
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE policy_disregards
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE proceedings
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE prohibited_steps
    ADD FOREIGN KEY (proceeding_id) REFERENCES proceedings(id);
ALTER TABLE providers
    ADD FOREIGN KEY (firm_id) REFERENCES firms(id);
ALTER TABLE providers
    ADD FOREIGN KEY (selected_office_id) REFERENCES offices(id);
ALTER TABLE regular_transactions
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id) ON DELETE CASCADE;
ALTER TABLE regular_transactions
    ADD FOREIGN KEY (transaction_type_id) REFERENCES transaction_types(id);
ALTER TABLE savings_amounts
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE scheduled_mailings
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id) ON DELETE CASCADE;
ALTER TABLE scope_limitations
    ADD FOREIGN KEY (proceeding_id) REFERENCES proceedings(id);
ALTER TABLE specific_issues
    ADD FOREIGN KEY (proceeding_id) REFERENCES proceedings(id);
ALTER TABLE statement_of_cases
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id) ON DELETE CASCADE;
ALTER TABLE statement_of_cases
    ADD FOREIGN KEY (provider_uploader_id) REFERENCES providers(id);
ALTER TABLE undertakings
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE uploaded_evidence_collections
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE urgencies
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);
ALTER TABLE vary_orders
    ADD FOREIGN KEY (proceeding_id) REFERENCES proceedings(id);
ALTER TABLE vehicles
    ADD FOREIGN KEY (legal_aid_application_id) REFERENCES legal_aid_applications(id);