import unittest
from myCode import extract_specific_data

class TestExtractSpecificData(unittest.TestCase):
    def test_extract_specific_data(self):
        # Define a sample input data
        sample_data = {
            "data": {
                "rates": {
                    "CZK": 25.0,
                    "EUR": 1.2,
                    "USD": 1.0
                }
            }
        }

        # Call the function with the sample data
        result = extract_specific_data(sample_data)

        # Assert the expected output
        expected_result = {"CZK": 25.0}
        self.assertEqual(result, expected_result, "Extracted specific data doesn't match expected result")

if __name__ == '__main__':
    unittest.main()
