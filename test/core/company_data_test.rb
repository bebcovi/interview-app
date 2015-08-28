require "./test/unit"
require "./core/company_data"

class CompanyDataTest < UnitTest
  def test_gathering
    statement_descriptors = [
      "POS DNSIMPLE.COM 3125490222 3,00 USD",
      "POS GITHUB.COM 11VI7 4154486673 25,00 USD",
    ]

    companies = CompanyData.gather(statement_descriptors)

    assert_equal "DNSimple", companies[0].name
    assert_equal "GitHub",   companies[1].name
  end

  def test_domain_matching
    assert_match CompanyData::DOMAIN_REGEXP, "stripe.com"

    refute_match CompanyData::DOMAIN_REGEXP, "stripe."
    refute_match CompanyData::DOMAIN_REGEXP, ".stripe"
    refute_match CompanyData::DOMAIN_REGEXP, "stripe"
  end

  def test_returning_nil_for_unknown_domains
    assert_equal [nil, nil], CompanyData.gather(["foo.foo", "bar.bar"])
  end

  def test_returning_nil_for_no_domain_matches
    assert_equal [nil, nil], CompanyData.gather(["foo", "bar"])
  end
end
