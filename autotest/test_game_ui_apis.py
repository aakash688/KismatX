#!/usr/bin/env python3
"""
KismatX Game UI API Test Suite
Comprehensive test cases for all game UI and player endpoints
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
    player_id: Optional[int] = None
    current_game_id: Optional[str] = None
    test_slip_id: Optional[str] = None
    test_barcode: Optional[str] = None
    results: List[TestResult] = field(default_factory=list)

class GameUITestSuite:
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

    def make_request(self, method: str, endpoint: str, use_player_token=False, **kwargs) -> requests.Response:
        """Make API request with optional player authentication"""
        url = f"{BASE_URL}{endpoint}"
        
        # Add player token if needed
        if use_player_token and self.test_session.player_token:
            self.session.headers["Authorization"] = f"Bearer {self.test_session.player_token}"
        elif not use_player_token and "Authorization" in self.session.headers:
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
        self.test_session.results.append(result)
        print(f"{result.status.value} {result.name}")
        if result.message:
            print(f"   → {result.message}")
        if result.error:
            print(f"   ⚠️  Error: {result.error}")
        
        self.report_data["tests_run"] += 1
        self.report_data["details"].append({
            "name": result.name,
            "status": result.status.value,
            "message": result.message,
            "error": result.error,
            "duration_ms": round(result.duration_ms, 2)
        })
        return result

    # ==================== AUTHENTICATION TESTS ====================

    def test_player_login(self, result: TestResult):
        """Test: Player Login"""
        response = self.make_request("POST", "/auth/login", json={
            "user_id": PLAYER_USERID,
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

    # ==================== PUBLIC GAME ENDPOINTS (NO AUTH) ====================

    def test_get_current_game_public(self, result: TestResult):
        """Test: Get Current Active Game (Public - No Auth)"""
        response = self.make_request("GET", "/games/current")
        if response.status_code == 200:
            data = response.json()
            if data.get("data") and data["data"].get("status") == "active":
                self.test_session.current_game_id = data["data"].get("game_id")
                result.status = TestStatus.PASS
                result.message = f"Active game found: {self.test_session.current_game_id}"
            else:
                result.status = TestStatus.WARN
                result.message = "No active game available (404 expected if no active game)"
                if response.status_code == 404:
                    result.message = "No active game (expected behavior)"
        elif response.status_code == 404:
            result.status = TestStatus.WARN
            result.message = "No active game at the moment (this is normal)"
        else:
            result.message = f"Expected 200 or 404, got {response.status_code}"

    def test_get_game_by_id_public(self, result: TestResult):
        """Test: Get Game by ID (Public - No Auth)"""
        # Try to get a game - if no current game, skip
        if not self.test_session.current_game_id:
            # Try with a date-based game ID
            test_game_id = datetime.now().strftime("%Y%m%d") + "1200"  # Today at 12:00
            response = self.make_request("GET", f"/games/{test_game_id}")
            if response.status_code == 200:
                data = response.json()
                result.status = TestStatus.PASS
                result.message = f"Game retrieved: {test_game_id}"
                result.response_data = data
            elif response.status_code == 404:
                result.status = TestStatus.SKIP
                result.message = f"Game {test_game_id} not found"
            else:
                result.message = f"Expected 200 or 404, got {response.status_code}"
        else:
            response = self.make_request("GET", f"/games/{self.test_session.current_game_id}")
            if response.status_code == 200:
                data = response.json()
                result.status = TestStatus.PASS
                result.message = f"Game retrieved: {self.test_session.current_game_id}"
                result.response_data = data
            else:
                result.message = f"Expected 200, got {response.status_code}"

    # ==================== PLAYER PROFILE TESTS ====================

    def test_get_my_profile(self, result: TestResult):
        """Test: Get My Profile"""
        response = self.make_request("GET", "/user/me", use_player_token=True)
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = f"Profile retrieved for: {data.get('user_id', data.get('userid', 'unknown'))}"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_get_user_profile(self, result: TestResult):
        """Test: Get User Profile"""
        response = self.make_request("GET", "/user/profile", use_player_token=True)
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "User profile retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_update_user_profile(self, result: TestResult):
        """Test: Update User Profile"""
        update_data = {
            "first_name": "Player",
            "last_name": "One"
        }
        response = self.make_request("PUT", "/user/profile", use_player_token=True, json=update_data)
        if response.status_code == 200:
            result.status = TestStatus.PASS
            result.message = "Profile updated successfully"
        else:
            result.message = f"Expected 200, got {response.status_code}"

    # ==================== BETTING TESTS ====================

    def test_place_bet(self, result: TestResult):
        """Test: Place Bet"""
        if not self.test_session.current_game_id:
            result.status = TestStatus.SKIP
            result.message = "No active game available"
            return
        
        idempotency_key = f"test-bet-{uuid.uuid4()}"
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

    def test_get_my_bets(self, result: TestResult):
        """Test: Get My Bets"""
        response = self.make_request("GET", "/bets/my-bets", use_player_token=True)
        if response.status_code == 200:
            data = response.json()
            bets = data.get("data", [])
            result.status = TestStatus.PASS
            result.message = f"Retrieved {len(bets)} bets"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_get_bet_slip(self, result: TestResult):
        """Test: Get Bet Slip by Identifier"""
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

    def test_claim_winnings(self, result: TestResult):
        """Test: Claim Winnings"""
        if not self.test_session.test_slip_id:
            result.status = TestStatus.SKIP
            result.message = "No slip ID available (game may not be settled yet)"
            return
        
        response = self.make_request("POST", "/bets/claim",
                                    use_player_token=True,
                                    json={"identifier": self.test_session.test_slip_id})
        if response.status_code == 200:
            data = response.json()
            if data.get("success"):
                result.status = TestStatus.PASS
                result.message = f"Winnings claimed: {data.get('data', {}).get('amount', 0)}"
                result.response_data = data
            else:
                result.message = "Claim response not successful"
        elif response.status_code == 400:
            # May already be claimed or game not settled
            result.status = TestStatus.WARN
            result.message = f"Claim not possible: {response.json().get('message', 'Unknown error')}"
        else:
            result.message = f"Expected 200, got {response.status_code}: {response.text}"

    # ==================== WALLET TESTS ====================

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
            transactions = data.get("data", [])
            result.status = TestStatus.PASS
            result.message = f"Retrieved {len(transactions)} transactions"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    # ==================== INPUT VALIDATION TESTS ====================

    def test_place_bet_invalid_card(self, result: TestResult):
        """Test: Place Bet with Invalid Card Number"""
        if not self.test_session.current_game_id:
            result.status = TestStatus.SKIP
            result.message = "No active game available"
            return
        
        bet_data = {
            "game_id": self.test_session.current_game_id,
            "bets": [{"card_number": 13, "bet_amount": 100}]  # Invalid card
        }
        
        response = self.make_request("POST", "/bets/place",
                                    use_player_token=True,
                                    json=bet_data)
        if response.status_code == 400:
            result.status = TestStatus.PASS
            result.message = "Correctly rejects invalid card number"
        else:
            result.message = f"Expected 400, got {response.status_code}"

    def test_place_bet_negative_amount(self, result: TestResult):
        """Test: Place Bet with Negative Amount"""
        if not self.test_session.current_game_id:
            result.status = TestStatus.SKIP
            result.message = "No active game available"
            return
        
        bet_data = {
            "game_id": self.test_session.current_game_id,
            "bets": [{"card_number": 5, "bet_amount": -100}]  # Negative amount
        }
        
        response = self.make_request("POST", "/bets/place",
                                    use_player_token=True,
                                    json=bet_data)
        if response.status_code == 400:
            result.status = TestStatus.PASS
            result.message = "Correctly rejects negative bet amount"
        else:
            result.message = f"Expected 400, got {response.status_code}"

    def test_place_bet_zero_amount(self, result: TestResult):
        """Test: Place Bet with Zero Amount"""
        if not self.test_session.current_game_id:
            result.status = TestStatus.SKIP
            result.message = "No active game available"
            return
        
        bet_data = {
            "game_id": self.test_session.current_game_id,
            "bets": [{"card_number": 5, "bet_amount": 0}]
        }
        
        response = self.make_request("POST", "/bets/place",
                                    use_player_token=True,
                                    json=bet_data)
        if response.status_code == 400:
            result.status = TestStatus.PASS
            result.message = "Correctly rejects zero bet amount"
        else:
            result.message = f"Expected 400, got {response.status_code}"

    # ==================== SECURITY TESTS ====================

    def test_unauthorized_bet_access(self, result: TestResult):
        """Test: Unauthorized Access to Betting Endpoints"""
        # Remove auth header
        if "Authorization" in self.session.headers:
            del self.session.headers["Authorization"]
        
        response = self.make_request("GET", "/bets/my-bets")
        if response.status_code == 401:
            result.status = TestStatus.PASS
            result.message = "Correctly requires authentication"
            # Restore token
            if self.test_session.player_token:
                self.session.headers["Authorization"] = f"Bearer {self.test_session.player_token}"
        else:
            result.message = f"Expected 401, got {response.status_code}"

    # ==================== RUN ALL TESTS ====================

    def run_all_tests(self):
        """Execute all game UI test cases"""
        print("=" * 80)
        print("🧪 KismatX Game UI API Test Suite")
        print("=" * 80)
        print(f"Base URL: {BASE_URL}")
        print(f"Player: {PLAYER_USERID}")
        print("=" * 80)

        # Authentication
        print("\n🔐 Authentication Tests")
        print("-" * 80)
        self.run_test("Player Login", self.test_player_login)

        # Public Game Endpoints
        print("\n🎮 Public Game Endpoints (No Auth Required)")
        print("-" * 80)
        self.run_test("Get Current Active Game (Public)", self.test_get_current_game_public)
        self.run_test("Get Game by ID (Public)", self.test_get_game_by_id_public)

        # Player Profile
        print("\n👤 Player Profile Tests")
        print("-" * 80)
        self.run_test("Get My Profile", self.test_get_my_profile)
        self.run_test("Get User Profile", self.test_get_user_profile)
        self.run_test("Update User Profile", self.test_update_user_profile)

        # Betting
        print("\n🎯 Betting Tests")
        print("-" * 80)
        self.run_test("Place Bet", self.test_place_bet)
        self.run_test("Get My Bets", self.test_get_my_bets)
        self.run_test("Get Bet Slip", self.test_get_bet_slip)
        self.run_test("Claim Winnings", self.test_claim_winnings)

        # Wallet
        print("\n💰 Wallet Tests")
        print("-" * 80)
        self.run_test("Get User Transactions", self.test_get_user_transactions)

        # Input Validation
        print("\n✅ Input Validation Tests")
        print("-" * 80)
        self.run_test("Place Bet - Invalid Card Number", self.test_place_bet_invalid_card)
        self.run_test("Place Bet - Negative Amount", self.test_place_bet_negative_amount)
        self.run_test("Place Bet - Zero Amount", self.test_place_bet_zero_amount)

        # Security
        print("\n🔒 Security Tests")
        print("-" * 80)
        self.run_test("Unauthorized Bet Access", self.test_unauthorized_bet_access)

        # Generate report
        self.generate_report()

    def generate_report(self):
        """Generate comprehensive test report"""
        self.report_data["end_time"] = datetime.now().isoformat()
        start = datetime.fromisoformat(self.report_data["start_time"])
        end = datetime.fromisoformat(self.report_data["end_time"])
        duration = (end - start).total_seconds()
        self.report_data["duration_seconds"] = round(duration, 2)
        
        total = self.report_data["tests_run"]
        passed = self.report_data["tests_passed"]
        self.report_data["pass_rate"] = round((passed / total * 100) if total > 0 else 0, 2)
        
        report_filename = f"game_ui_test_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_filename, "w") as f:
            json.dump(self.report_data, f, indent=2)
        
        print("\n" + "=" * 80)
        print("📊 GAME UI TEST SUMMARY")
        print("=" * 80)
        print(f"Tests Run:       {self.report_data['tests_run']}")
        print(f"✅ Passed:       {self.report_data['tests_passed']}")
        print(f"❌ Failed:       {self.report_data['tests_failed']}")
        print(f"⏭️  Skipped:      {self.report_data['tests_skipped']}")
        print(f"📈 Pass Rate:    {self.report_data['pass_rate']}%")
        print(f"⏱️  Duration:     {self.report_data['duration_seconds']}s")
        print(f"📄 Report:       {report_filename}")
        print("=" * 80)

if __name__ == "__main__":
    suite = GameUITestSuite()
    suite.run_all_tests()

