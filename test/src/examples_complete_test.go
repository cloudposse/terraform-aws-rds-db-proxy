package test

import (
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func cleanup(t *testing.T, terraformOptions *terraform.Options, tempTestFolder string) {
	terraform.Destroy(t, terraformOptions)
	os.RemoveAll(tempTestFolder)
}

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()
	randID := strings.ToLower(random.UniqueId())
	attributes := []string{randID}

	rootFolder := "../../"
	terraformFolderRelativeToRoot := "examples/complete"
	varFiles := []string{"fixtures.us-east-2.tfvars"}

	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: tempTestFolder,
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: varFiles,
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer cleanup(t, terraformOptions, tempTestFolder)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	vpcCidr := terraform.Output(t, terraformOptions, "vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.16.0.0/16", vpcCidr)

	// Run `terraform output` to get the value of an output variable
	privateSubnetCidrs := terraform.OutputList(t, terraformOptions, "private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.0.0/19", "172.16.32.0/19"}, privateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	publicSubnetCidrs := terraform.OutputList(t, terraformOptions, "public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.96.0/19", "172.16.128.0/19"}, publicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	instanceId := terraform.Output(t, terraformOptions, "instance_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-rds-proxy-"+randID, instanceId)

	// Run `terraform output` to get the value of an output variable
	optionGroupId := terraform.Output(t, terraformOptions, "option_group_id")
	// We expect AWS to tack a uniquifier on to the end
	assert.Contains(t, optionGroupId, "eg-test-rds-proxy-"+randID)

	// Run `terraform output` to get the value of an output variable
	parameterGroupId := terraform.Output(t, terraformOptions, "parameter_group_id")
	// We expect AWS to tack a uniquifier on to the end
	assert.Contains(t, parameterGroupId, "eg-test-rds-proxy-"+randID)

	// Run `terraform output` to get the value of an output variable
	subnetGroupId := terraform.Output(t, terraformOptions, "subnet_group_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-rds-proxy-"+randID, subnetGroupId)

	// Run `terraform output` to get the value of an output variable
	proxyId := terraform.Output(t, terraformOptions, "proxy_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-rds-proxy-"+randID, proxyId)

	// Run `terraform output` to get the value of an output variable
	proxyEndpoint := terraform.Output(t, terraformOptions, "proxy_endpoint")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, proxyEndpoint, "eg-test-rds-proxy-"+randID)

	// Run `terraform output` to get the value of an output variable
	proxyTargetEndpoint := terraform.Output(t, terraformOptions, "proxy_target_endpoint")
	instanceAddress := terraform.Output(t, terraformOptions, "instance_address")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, proxyTargetEndpoint, instanceAddress)

	// Run `terraform output` to get the value of an output variable
	proxyTargetReadEndpoint := terraform.Output(t, terraformOptions, "proxy_read_endpoint_name")
	assert.NotEmpty(t, proxyTargetReadEndpoint)
	assert.Contains(t, proxyTargetReadEndpoint, "eg-test-rds-proxy-"+randID+"-read-only")
}
