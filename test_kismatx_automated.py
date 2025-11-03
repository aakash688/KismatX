#!/usr/bin/env python3
"""
KismatX Automated Test Suite
Comprehensive API testing script that validates all endpoints and functionality
"""

import requests
import json
import uuid
import time
from datetime import datetime
from typing import Dict, Any, Optional, List
from dataclasses import dataclass, field
from enum import Enum

# Configuration
BASE_URL = "http://localhost:5001/api"
PLAYER_USERID = "player001"
PLAYER_PASSWORD = "password123"
ADMIN_USERID = "admin001"
ADMIN_PASSWORD = "admin123"
WALLET_RECHARGE_AMOUNT = 1000

class TestStatus(Enum):
    PASS = "✅ PASS"
    FAIL = "❌ FAIL"
    SKIP = "⏭️  SKIP"
    WARN = "⚠️  WARN"

@dataclass
class TestResult:
    name: str
    status: TestStatus
    message: str = ""
    response_data: Any = None
    error: Optional[str] = None
    duration_ms: float = 0.0

@dataclass
class TestSession:
    player_token: str = ""
    admin_token: str = ""
    player_id: Optional[int] = None
    current_game_id: Optional[str] = None
    test_slip_id: Optional[str] = None
    test_barcode: Optional[str] = None
    test_idempotency_key: Optional[str] = None
    results: List[TestResult] = field(default_factory=list)
    
    def add_result(self, result: TestResult):
        self.results.append(result)
        status_icon = result.status.value
        print(f"{status_icon} {result.name}")
        if result.message:
            print(f"   → {result.message}")
        if result.error:
            print(f"   ⚠️  Error: {result.error}")

class KismatXTestSuite:
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            "Content-Type": "application/json",
            "Accept": "application/json"
        })
        self.test_session = TestSession()
        self.report_data = {
            "start_time": datetime.now().isoformat(),
            "tests_run": 0,
            "tests_passed": 0,
            "tests_failed": 0,
            "tests_skipped": 0,
            "details": []
        }
    
    def log_request(self, method: str, endpoint: str, **kwargs):
        """Log API request details"""
        url = f"{BASE_URL}{endpoint}"
        print(f"\n📡 {method} {endpoint}")
        if "json" in kwargs:
            print(f"   Body: {json.dumps(kwargs['json'], indent=2)}")
    
    def make_request(self, method: str, endpoint: str, use_player_token=False, 
                    use_admin_token=False, **kwargs) -> requests.Response:
        """Make API request with appropriate authentication"""
        url = f"{BASE_URL}{endpoint}"
        
        # Add authentication header
        if use_player_token and self.test_session.player_token:
            self.session.headers["Authorization"] = f"Bearer {self.test_session.player_token}"
        elif use_admin_token and self.test_session.admin_token:
            self.session.headers["Authorization"] = f"Bearer {self.test_session.admin_token}"
        elif "Authorization" in self.session.headers:
            del self.session.headers["Authorization"]
        
        # Log request
        self.log_request(method, endpoint, **kwargs)
        
        # Make request
        try:
            response = self.session.request(method, url, **kwargs)
            print(f"   Status: {response.status_code}")
            if response.text:
                try:
                    print(f"   Response: {json.dumps(response.json(), indent=2)[:500]}")
                except:
                    print(f"   Response: {response.text[:500]}")
            return response
        except Exception as e:
            print(f"   ❌ Request failed: {str(e)}")
            raise
    
    def run_test(self, name: str, test_func) -> TestResult:
        """Run a test function and record the result"""
        start_time = time.time()
        result = TestResult(name=name, status=TestStatus.FAIL, message="", error=None)
        
        try:
            test_func(result)
            if result.status == TestStatus.PASS:
                self.report_data["tests_passed"] += 1
            elif result.status == TestStatus.FAIL:
                self.report_data["tests_failed"] += 1
            elif result.status == TestStatus.SKIP:
                self.report_data["tests_skipped"] += 1
        except Exception as e:
            result.status = TestStatus.FAIL
            result.error = str(e)
            result.message = f"Test exception: {str(e)}"
            self.report_data["tests_failed"] += 1
        
        result.duration_ms = (time.time() - start_time) * 1000
        self.test_session.add_result(result)
        self.report_data["tests_run"] += 1
        self.report_data["details"].append({
            "name": result.name,
            "status": result.status.value,
            "message": result.message,
            "error": result.error,
            "duration_ms": round(result.duration_ms, 2)
        })
        return result
    
    # ==================== TEST METHODS ====================
    
    def test_health_check(self, result: TestResult):
        """Test 1: Health Check"""
        response = self.make_request("GET", "/health")
        if response.status_code == 200:
            data = response.json()
            if data.get("status") == "OK":
                result.status = TestStatus.PASS
                result.message = "Server is healthy"
                result.response_data = data
            else:
                result.message = f"Unexpected status: {data.get('status')}"
        else:
            result.message = f"Expected 200, got {response.status_code}"
    
    def test_current_game_no_active(self, result: TestResult):
        """Test 2: Current Game (No active game yet)"""
        response = self.make_request("GET", "/games/current")
        if response.status_code == 404:
            result.status = TestStatus.PASS
            result.message = "Correctly returns 404 when no active game"
        elif response.status_code == 200:
            data = response.json()
            if data.get("data") and data["data"].get("status") == "active":
                result.status = TestStatus.PASS
                result.message = "Active game found (test will use it)"
                self.test_session.current_game_id = data["data"].get("game_id")
            else:
                result.status = TestStatus.WARN
                result.message = "Game exists but not active"
        else:
            result.message = f"Expected 404 or 200, got {response.status_code}"
    
    def test_player_login(self, result: TestResult):
        """Test 6: Player Login"""
        response = self.make_request("POST", "/auth/login", json={
            "userid": PLAYER_USERID,
            "password": PLAYER_PASSWORD
        })
        if response.status_code == 200:
            data = response.json()
            if "accessToken" in data:
                self.test_session.player_token = data["accessToken"]
                self.test_session.player_id = data.get("user", {}).get("id")
                result.status = TestStatus.PASS
                result.message = f"Player logged in successfully (ID: {self.test_session.player_id})"
                result.response_data = {"token_received": True, "user_id": self.test_session.player_id}
            else:
                result.message = "No accessToken in response"
        else:
            result.message = f"Expected 200, got {response.status_code}: {response.text}"
    
    def test_admin_login(self, result: TestResult):
        """Admin Login (required for wallet recharge)"""
        response = self.make_request("POST", "/auth/login", json={
            "userid": ADMIN_USERID,
            "password": ADMIN_PASSWORD
        })
        if response.status_code == 200:
            data = response.json()
            if "accessToken" in data:
                self.test_session.admin_token = data["accessToken"]
                result.status = TestStatus.PASS
                result.message = "Admin logged in successfully"
            else:
                result.message = "No accessToken in response"
        else:
            result.message = f"Expected 200, got {response.status_code}: {response.text}"
    
    def test_wallet_recharge(self, result: TestResult):
        """Test 7: Recharge Wallet (Admin action)"""
        if not self.test_session.player_id:
            result.status = TestStatus.SKIP
            result.message = "Player ID not available, skipping"
            return
        
        response = self.make_request("POST", "/wallet/transaction", 
                                    use_admin_token=True,
                                    json={
            "user_id": self.test_session.player_id,
            "transaction_type": "recharge",
            "amount": WALLET_RECHARGE_AMOUNT,
            "transaction_direction": "credit",
            "comment": f"Automated test recharge - {datetime.now().isoformat()}"
        })
        if response.status_code in [200, 201]:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = f"Wallet recharged with {WALLET_RECHARGE_AMOUNT}"
            result.response_data = data
        else:
            result.message = f"Expected 200/201, got {response.status_code}: {response.text}"
    
    def test_get_current_game(self, result: TestResult):
        """Get or activate current game for betting"""
        response = self.make_request("GET", "/games/current")
        if response.status_code == 200:
            data = response.json()
            if data.get("data") and data["data"].get("status") == "active":
                self.test_session.current_game_id = data["data"].get("game_id")
                result.status = TestStatus.PASS
                result.message = f"Active game found: {self.test_session.current_game_id}"
            else:
                result.status = TestStatus.WARN
                result.message = "No active game - may need manual game creation"
        else:
            result.status = TestStatus.SKIP
            result.message = f"No active game (status {response.status_code}) - skipping betting tests"
    
    def test_place_bet(self, result: TestResult):
        """Test 8: Place Bet"""
        if not self.test_session.current_game_id:
            result.status = TestStatus.SKIP
            result.message = "No active game available"
            return
        
        idempotency_key = f"test-bet-{uuid.uuid4()}"
        self.test_session.test_idempotency_key = idempotency_key  # Save for idempotency test
        bet_data = {
            "game_id": self.test_session.current_game_id,
            "bets": [
                {"card_number": 5, "bet_amount": 100},
                {"card_number": 7, "bet_amount": 150}
            ]
        }
        
        response = self.make_request("POST", "/bets/place",
                                    use_player_token=True,
                                    headers={"X-Idempotency-Key": idempotency_key},
                                    json=bet_data)
        if response.status_code == 201:
            data = response.json()
            if data.get("success") and data.get("data"):
                self.test_session.test_slip_id = data["data"].get("slip_id")
                self.test_session.test_barcode = data["data"].get("barcode")
                result.status = TestStatus.PASS
                result.message = f"Bet placed successfully (Total: {data['data'].get('total_amount')})"
                result.response_data = data["data"]
            else:
                result.message = "Response missing success or data field"
        else:
            result.message = f"Expected 201, got {response.status_code}: {response.text}"
    
    def test_idempotency_check(self, result: TestResult):
        """Test 9: Idempotency Check"""
        if not self.test_session.current_game_id or not self.test_session.test_slip_id:
            result.status = TestStatus.SKIP
            result.message = "No bet placed yet"
            return
        
        if not self.test_session.test_idempotency_key:
            result.status = TestStatus.SKIP
            result.message = "No idempotency key from previous bet"
            return
        
        # Use same idempotency key as previous bet
        bet_data = {
            "game_id": self.test_session.current_game_id,
            "bets": [
                {"card_number": 5, "bet_amount": 100},
                {"card_number": 7, "bet_amount": 150}
            ]
        }
        
        # Try placing the same bet again with same idempotency key
        response = self.make_request("POST", "/bets/place",
                                    use_player_token=True,
                                    headers={"X-Idempotency-Key": self.test_session.test_idempotency_key},
                                    json=bet_data)
        
        if response.status_code == 200:
            data = response.json()
            returned_slip_id = data.get("data", {}).get("slip_id")
            if returned_slip_id == self.test_session.test_slip_id:
                result.status = TestStatus.PASS
                result.message = "Idempotency working: same slip_id returned for duplicate request"
            else:
                result.message = f"Different slip_ids: {self.test_session.test_slip_id} vs {returned_slip_id}"
        elif response.status_code == 201:
            result.message = "Received 201 (new bet created) - idempotency may not be working"
        else:
            result.message = f"Expected 200 for duplicate, got {response.status_code}: {response.text}"
    
    def test_get_my_bets(self, result: TestResult):
        """Test: Get My Bets"""
        response = self.make_request("GET", "/bets/my-bets", use_player_token=True)
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = f"Retrieved bet history (found {len(data.get('data', []))} bets)"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"
    
    def test_get_bet_slip(self, result: TestResult):
        """Test: Get Bet Slip by ID"""
        if not self.test_session.test_slip_id:
            result.status = TestStatus.SKIP
            result.message = "No slip ID available"
            return
        
        response = self.make_request("GET", f"/bets/slip/{self.test_session.test_slip_id}",
                                    use_player_token=True)
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Bet slip retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"
    
    def test_settle_game(self, result: TestResult):
        """Test 11: Settle Game (Admin)"""
        if not self.test_session.current_game_id:
            result.status = TestStatus.SKIP
            result.message = "No game ID available"
            return
        
        response = self.make_request("POST", f"/admin/games/{self.test_session.current_game_id}/settle",
                                    use_admin_token=True,
                                    json={"winning_card": 7})
        if response.status_code == 200:
            data = response.json()
            if data.get("success"):
                result.status = TestStatus.PASS
                result.message = f"Game settled successfully (Card 7 wins)"
                result.response_data = data
            else:
                result.message = "Settlement response not successful"
        else:
            result.message = f"Expected 200, got {response.status_code}: {response.text}"
    
    def test_claim_winnings(self, result: TestResult):
        """Test 12: Claim Winnings"""
        if not self.test_session.test_slip_id:
            result.status = TestStatus.SKIP
            result.message = "No slip ID available"
            return
        
        response = self.make_request("POST", "/bets/claim",
                                    use_player_token=True,
                                    json={"identifier": self.test_session.test_slip_id})
        if response.status_code == 200:
            data = response.json()
            if data.get("success"):
                result.status = TestStatus.PASS
                result.message = f"Winnings claimed: {data.get('amount')} (New balance: {data.get('new_balance')})"
                result.response_data = data
            else:
                result.message = "Claim response not successful"
        else:
            result.message = f"Expected 200, got {response.status_code}: {response.text}"
    
    def test_duplicate_claim_prevention(self, result: TestResult):
        """Test 13: Duplicate Claim Prevention"""
        if not self.test_session.test_slip_id:
            result.status = TestStatus.SKIP
            result.message = "No slip ID available"
            return
        
        # Try to claim again
        response = self.make_request("POST", "/bets/claim",
                                    use_player_token=True,
                                    json={"identifier": self.test_session.test_slip_id})
        if response.status_code == 400:
            data = response.json()
            if "already claimed" in data.get("message", "").lower():
                result.status = TestStatus.PASS
                result.message = "Correctly prevented duplicate claim"
            else:
                result.message = f"Wrong error message: {data.get('message')}"
        else:
            result.message = f"Expected 400, got {response.status_code}: {response.text}"
    
    def test_admin_list_games(self, result: TestResult):
        """Test 14: List All Games (Admin)"""
        response = self.make_request("GET", "/admin/games", use_admin_token=True)
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = f"Retrieved games list (found {len(data.get('data', []))} games)"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"
    
    def test_admin_game_stats(self, result: TestResult):
        """Test 15: Game Statistics (Admin)"""
        if not self.test_session.current_game_id:
            result.status = TestStatus.SKIP
            result.message = "No game ID available"
            return
        
        response = self.make_request("GET", f"/admin/games/{self.test_session.current_game_id}/stats",
                                    use_admin_token=True)
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Game statistics retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"
    
    def test_admin_settlement_report(self, result: TestResult):
        """Test 16: Settlement Report (Admin)"""
        if not self.test_session.current_game_id:
            result.status = TestStatus.SKIP
            result.message = "No game ID available"
            return
        
        response = self.make_request("GET", f"/admin/games/{self.test_session.current_game_id}/settlement-report",
                                    use_admin_token=True)
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Settlement report retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"
    
    def test_admin_get_settings(self, result: TestResult):
        """Test 17: Get Settings (Admin)"""
        response = self.make_request("GET", "/admin/settings", use_admin_token=True)
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Settings retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"
    
    def test_admin_update_setting(self, result: TestResult):
        """Test 17: Update Setting (Admin)"""
        # Get current settings first
        get_response = self.make_request("GET", "/admin/settings", use_admin_token=True)
        original_multiplier = "10"
        
        if get_response.status_code == 200:
            data = get_response.json()
            if data.get("settings"):
                original_multiplier = data["settings"].get("game_multiplier", "10")
        
        # Try updating game_multiplier (restore to original)
        response = self.make_request("PUT", "/admin/settings",
                                    use_admin_token=True,
                                    json={
            "game_multiplier": original_multiplier  # Restore to original
        })
        if response.status_code in [200, 201]:
            result.status = TestStatus.PASS
            result.message = f"Setting updated successfully (multiplier: {original_multiplier})"
        else:
            result.status = TestStatus.WARN
            result.message = f"Expected 200/201, got {response.status_code}: {response.text}"
    
    def test_get_user_profile(self, result: TestResult):
        """Test: Get User Profile"""
        response = self.make_request("GET", "/user/me", use_player_token=True)
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = f"Profile retrieved for: {data.get('userid', 'unknown')}"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"
    
    def test_get_user_transactions(self, result: TestResult):
        """Test: Get User Transactions"""
        if not self.test_session.player_id:
            result.status = TestStatus.SKIP
            result.message = "Player ID not available"
            return
        
        response = self.make_request("GET", f"/wallet/{self.test_session.player_id}",
                                    use_player_token=True)
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = f"Retrieved {len(data.get('data', []))} transactions"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"
    
    def test_security_unauthorized_access(self, result: TestResult):
        """Test 21: Authentication Enforcement"""
        # Remove auth header
        if "Authorization" in self.session.headers:
            del self.session.headers["Authorization"]
        
        response = self.make_request("GET", "/bets/my-bets")
        if response.status_code == 401:
            result.status = TestStatus.PASS
            result.message = "Correctly requires authentication"
        else:
            result.message = f"Expected 401, got {response.status_code}"
    
    def test_security_admin_only(self, result: TestResult):
        """Test 21: Admin-only Route Protection"""
        # Try accessing admin endpoint as regular user
        response = self.make_request("GET", "/admin/games", use_player_token=True)
        if response.status_code == 403:
            result.status = TestStatus.PASS
            result.message = "Correctly restricts admin routes"
        else:
            result.message = f"Expected 403, got {response.status_code}"
    
    def test_input_validation_invalid_card(self, result: TestResult):
        """Test 23: Input Validation - Invalid Card"""
        if not self.test_session.current_game_id:
            result.status = TestStatus.SKIP
            result.message = "No active game available"
            return
        
        response = self.make_request("POST", "/bets/place",
                                    use_player_token=True,
                                    json={
            "game_id": self.test_session.current_game_id,
            "bets": [{"card_number": 13, "bet_amount": 100}]  # Invalid card
        })
        if response.status_code == 400:
            result.status = TestStatus.PASS
            result.message = "Correctly rejects invalid card number"
        else:
            result.message = f"Expected 400, got {response.status_code}"
    
    def test_input_validation_negative_amount(self, result: TestResult):
        """Test 23: Input Validation - Negative Amount"""
        if not self.test_session.current_game_id:
            result.status = TestStatus.SKIP
            result.message = "No active game available"
            return
        
        response = self.make_request("POST", "/bets/place",
                                    use_player_token=True,
                                    json={
            "game_id": self.test_session.current_game_id,
            "bets": [{"card_number": 5, "bet_amount": -100}]  # Negative amount
        })
        if response.status_code == 400:
            result.status = TestStatus.PASS
            result.message = "Correctly rejects negative bet amount"
        else:
            result.message = f"Expected 400, got {response.status_code}"
    
    # ==================== RUN ALL TESTS ====================
    
    def run_all_tests(self):
        """Execute all test cases in sequence"""
        print("=" * 80)
        print("🧪 KismatX Automated Test Suite")
        print("=" * 80)
        print(f"Base URL: {BASE_URL}")
        print(f"Player: {PLAYER_USERID}")
        print(f"Admin: {ADMIN_USERID}")
        print("=" * 80)
        
        # Step 1: Pre-flight checks
        print("\n📋 STEP 1: Pre-Flight Checks")
        print("-" * 80)
        self.run_test("1.1 Health Check", self.test_health_check)
        self.run_test("1.2 Current Game Check", self.test_current_game_no_active)
        
        # Step 2: Authentication
        print("\n🔐 STEP 2: Authentication")
        print("-" * 80)
        self.run_test("2.1 Player Login", self.test_player_login)
        self.run_test("2.2 Admin Login", self.test_admin_login)
        
        # Step 3: Wallet Management
        print("\n💰 STEP 3: Wallet Management")
        print("-" * 80)
        self.run_test("3.1 Wallet Recharge", self.test_wallet_recharge)
        self.run_test("3.2 Get User Transactions", self.test_get_user_transactions)
        
        # Step 4: Game & Betting
        print("\n🎮 STEP 4: Game & Betting")
        print("-" * 80)
        self.run_test("4.1 Get Current Game", self.test_get_current_game)
        
        if self.test_session.current_game_id:
            self.run_test("4.2 Place Bet", self.test_place_bet)
            self.run_test("4.3 Idempotency Check", self.test_idempotency_check)
            self.run_test("4.4 Get My Bets", self.test_get_my_bets)
            self.run_test("4.5 Get Bet Slip", self.test_get_bet_slip)
        else:
            print("⚠️  Skipping betting tests - no active game available")
        
        # Step 5: Settlement & Claims
        print("\n🏆 STEP 5: Settlement & Claims")
        print("-" * 80)
        if self.test_session.current_game_id:
            self.run_test("5.1 Settle Game", self.test_settle_game)
            if self.test_session.test_slip_id:
                self.run_test("5.2 Claim Winnings", self.test_claim_winnings)
                self.run_test("5.3 Duplicate Claim Prevention", self.test_duplicate_claim_prevention)
        
        # Step 6: Admin Functions
        print("\n👑 STEP 6: Admin Functions")
        print("-" * 80)
        self.run_test("6.1 List All Games", self.test_admin_list_games)
        if self.test_session.current_game_id:
            self.run_test("6.2 Game Statistics", self.test_admin_game_stats)
            self.run_test("6.3 Settlement Report", self.test_admin_settlement_report)
        self.run_test("6.4 Get Settings", self.test_admin_get_settings)
        self.run_test("6.5 Update Setting", self.test_admin_update_setting)
        
        # Step 7: User Profile
        print("\n👤 STEP 7: User Profile")
        print("-" * 80)
        self.run_test("7.1 Get User Profile", self.test_get_user_profile)
        
        # Step 8: Security Tests
        print("\n🛡️  STEP 8: Security Tests")
        print("-" * 80)
        self.run_test("8.1 Unauthorized Access", self.test_security_unauthorized_access)
        self.run_test("8.2 Admin Route Protection", self.test_security_admin_only)
        self.run_test("8.3 Input Validation - Invalid Card", self.test_input_validation_invalid_card)
        self.run_test("8.4 Input Validation - Negative Amount", self.test_input_validation_negative_amount)
        
        # Generate report
        self.generate_report()
    
    def generate_report(self):
        """Generate comprehensive test report"""
        self.report_data["end_time"] = datetime.now().isoformat()
        start = datetime.fromisoformat(self.report_data["start_time"])
        end = datetime.fromisoformat(self.report_data["end_time"])
        duration = (end - start).total_seconds()
        self.report_data["duration_seconds"] = round(duration, 2)
        
        # Calculate pass rate
        total = self.report_data["tests_run"]
        passed = self.report_data["tests_passed"]
        self.report_data["pass_rate"] = round((passed / total * 100) if total > 0 else 0, 2)
        
        # Save JSON report
        report_filename = f"test_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_filename, "w") as f:
            json.dump(self.report_data, f, indent=2)
        
        # Print summary
        print("\n" + "=" * 80)
        print("📊 TEST SUMMARY")
        print("=" * 80)
        print(f"Tests Run:       {self.report_data['tests_run']}")
        print(f"✅ Passed:       {self.report_data['tests_passed']}")
        print(f"❌ Failed:       {self.report_data['tests_failed']}")
        print(f"⏭️  Skipped:      {self.report_data['tests_skipped']}")
        print(f"📈 Pass Rate:    {self.report_data['pass_rate']}%")
        print(f"⏱️  Duration:     {self.report_data['duration_seconds']}s")
        print(f"📄 Report:       {report_filename}")
        print("=" * 80)
        
        # Detailed results
        print("\n📋 DETAILED RESULTS:")
        print("-" * 80)
        for detail in self.report_data["details"]:
            status = detail["status"]
            name = detail["name"]
            message = detail.get("message", "")
            duration = detail.get("duration_ms", 0)
            print(f"{status} {name:<50} ({duration:.0f}ms)")
            if message:
                print(f"    → {message}")
        
        # Final status
        print("\n" + "=" * 80)
        if self.report_data["tests_failed"] == 0:
            print("🎉 ALL TESTS PASSED!")
        elif self.report_data["pass_rate"] >= 80:
            print("⚠️  MOSTLY PASSED - Review failures above")
        else:
            print("❌ MULTIPLE FAILURES - Review details above")
        print("=" * 80)

if __name__ == "__main__":
    suite = KismatXTestSuite()
    suite.run_all_tests()

