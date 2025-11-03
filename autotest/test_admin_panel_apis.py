#!/usr/bin/env python3
"""
KismatX Admin Panel API Test Suite
Comprehensive test cases for all admin panel endpoints
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
ADMIN_USERID = "admin001"
ADMIN_PASSWORD = "admin123"

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
    admin_token: str = ""
    test_user_id: Optional[int] = None
    test_role_id: Optional[int] = None
    test_permission_id: Optional[int] = None
    test_game_id: Optional[str] = None
    results: List[TestResult] = field(default_factory=list)

class AdminPanelTestSuite:
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

    def make_request(self, method: str, endpoint: str, **kwargs) -> requests.Response:
        """Make API request with admin authentication"""
        url = f"{BASE_URL}{endpoint}"
        
        # Add admin token
        if self.test_session.admin_token:
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

    def test_admin_login(self, result: TestResult):
        """Test: Admin Login"""
        response = self.make_request("POST", "/auth/login", json={
            "user_id": ADMIN_USERID,
            "password": ADMIN_PASSWORD
        })
        if response.status_code == 200:
            data = response.json()
            if "accessToken" in data:
                self.test_session.admin_token = data["accessToken"]
                result.status = TestStatus.PASS
                result.message = "Admin logged in successfully"
                result.response_data = {"token_received": True}
            else:
                result.message = "No accessToken in response"
        else:
            result.message = f"Expected 200, got {response.status_code}: {response.text}"

    # ==================== DASHBOARD TESTS ====================

    def test_get_dashboard(self, result: TestResult):
        """Test: Get Admin Dashboard"""
        response = self.make_request("GET", "/admin/dashboard")
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Dashboard data retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    # ==================== USER MANAGEMENT TESTS ====================

    def test_get_all_users(self, result: TestResult):
        """Test: Get All Users with Pagination"""
        response = self.make_request("GET", "/admin/users?page=1&limit=10")
        if response.status_code == 200:
            data = response.json()
            users = data.get('users', data.get('data', []))
            result.status = TestStatus.PASS
            result.message = f"Retrieved {len(users)} users"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_create_user(self, result: TestResult):
        """Test: Create New User"""
        # First get roles to find Player role ID
        roles_response = self.make_request("GET", "/admin/roles")
        player_role_id = None
        if roles_response.status_code == 200:
            roles_data = roles_response.json()
            roles = roles_data.get("data", roles_data.get("roles", []))
            for role in roles:
                if role.get("name", "").lower() == "player":
                    player_role_id = role.get("id")
                    break
        
        test_user_data = {
            "user_id": f"testuser_{uuid.uuid4().hex[:8]}",
            "first_name": "Test",
            "last_name": "User",
            "email": f"test_{uuid.uuid4().hex[:8]}@example.com",
            "mobile": f"98765{uuid.uuid4().hex[:5]}",
            "password": "Test@1234",
            "user_type": "player",
            "deposit_amount": 100,
            "roles": [player_role_id] if player_role_id else []
        }
        
        response = self.make_request("POST", "/admin/users", json=test_user_data)
        if response.status_code in [200, 201]:
            data = response.json()
            if data.get("user"):
                self.test_session.test_user_id = data["user"].get("id")
                result.status = TestStatus.PASS
                result.message = f"User created successfully (ID: {self.test_session.test_user_id})"
                result.response_data = data
            else:
                result.message = "Response missing user data"
        else:
            result.message = f"Expected 200/201, got {response.status_code}: {response.text}"

    def test_get_user_by_id(self, result: TestResult):
        """Test: Get User by ID"""
        if not self.test_session.test_user_id:
            result.status = TestStatus.SKIP
            result.message = "No user ID available"
            return
        
        response = self.make_request("GET", f"/admin/users/{self.test_session.test_user_id}")
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "User retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_update_user(self, result: TestResult):
        """Test: Update User"""
        if not self.test_session.test_user_id:
            result.status = TestStatus.SKIP
            result.message = "No user ID available"
            return
        
        update_data = {
            "first_name": "Test Updated",
            "last_name": "User Updated"
        }
        
        response = self.make_request("PUT", f"/admin/users/{self.test_session.test_user_id}", json=update_data)
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "User updated successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_change_user_status(self, result: TestResult):
        """Test: Change User Status"""
        if not self.test_session.test_user_id:
            result.status = TestStatus.SKIP
            result.message = "No user ID available"
            return
        
        response = self.make_request("PUT", f"/admin/users/{self.test_session.test_user_id}/status", json={
            "status": "active"
        })
        if response.status_code == 200:
            result.status = TestStatus.PASS
            result.message = "User status updated successfully"
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_reset_user_password(self, result: TestResult):
        """Test: Reset User Password"""
        if not self.test_session.test_user_id:
            result.status = TestStatus.SKIP
            result.message = "No user ID available"
            return
        
        response = self.make_request("POST", f"/admin/users/{self.test_session.test_user_id}/reset-password", json={
            "newPassword": "NewPassword@123"
        })
        if response.status_code in [200, 201]:
            result.status = TestStatus.PASS
            result.message = "User password reset successfully"
        else:
            result.message = f"Expected 200/201, got {response.status_code}"

    def test_verify_user_email(self, result: TestResult):
        """Test: Verify User Email"""
        if not self.test_session.test_user_id:
            result.status = TestStatus.SKIP
            result.message = "No user ID available"
            return
        
        response = self.make_request("PUT", f"/admin/users/{self.test_session.test_user_id}/verify-email")
        if response.status_code == 200:
            result.status = TestStatus.PASS
            result.message = "User email verified successfully"
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_verify_user_mobile(self, result: TestResult):
        """Test: Verify User Mobile"""
        if not self.test_session.test_user_id:
            result.status = TestStatus.SKIP
            result.message = "No user ID available"
            return
        
        response = self.make_request("PUT", f"/admin/users/{self.test_session.test_user_id}/verify-mobile")
        if response.status_code == 200:
            result.status = TestStatus.PASS
            result.message = "User mobile verified successfully"
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_get_user_login_history(self, result: TestResult):
        """Test: Get User Login History"""
        if not self.test_session.test_user_id:
            result.status = TestStatus.SKIP
            result.message = "No user ID available"
            return
        
        response = self.make_request("GET", f"/admin/users/{self.test_session.test_user_id}/logins?page=1&limit=10")
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = f"Retrieved login history"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_kill_user_sessions(self, result: TestResult):
        """Test: Kill User Sessions"""
        if not self.test_session.test_user_id:
            result.status = TestStatus.SKIP
            result.message = "No user ID available"
            return
        
        response = self.make_request("POST", f"/admin/users/{self.test_session.test_user_id}/sessions/kill")
        if response.status_code in [200, 201]:
            result.status = TestStatus.PASS
            result.message = "User sessions killed successfully"
        else:
            result.message = f"Expected 200/201, got {response.status_code}"

    def test_get_user_active_sessions(self, result: TestResult):
        """Test: Get User Active Sessions"""
        if not self.test_session.test_user_id:
            result.status = TestStatus.SKIP
            result.message = "No user ID available"
            return
        
        response = self.make_request("GET", f"/admin/users/{self.test_session.test_user_id}/sessions/active")
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Active sessions retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    # ==================== ROLE MANAGEMENT TESTS ====================

    def test_get_all_roles(self, result: TestResult):
        """Test: Get All Roles"""
        response = self.make_request("GET", "/admin/roles")
        if response.status_code == 200:
            data = response.json()
            roles = data.get("data", data.get("roles", []))
            if roles:
                self.test_session.test_role_id = roles[0].get("id")
            result.status = TestStatus.PASS
            result.message = f"Retrieved {len(roles)} roles"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_create_role(self, result: TestResult):
        """Test: Create Role"""
        role_data = {
            "name": f"test_role_{uuid.uuid4().hex[:8]}",
            "description": "Test role for automation",
            "permissions": []
        }
        
        response = self.make_request("POST", "/admin/roles", json=role_data)
        if response.status_code in [200, 201]:
            data = response.json()
            if data.get("role"):
                self.test_session.test_role_id = data["role"].get("id")
            result.status = TestStatus.PASS
            result.message = "Role created successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200/201, got {response.status_code}: {response.text}"

    def test_get_role_permissions(self, result: TestResult):
        """Test: Get Role Permissions"""
        if not self.test_session.test_role_id:
            result.status = TestStatus.SKIP
            result.message = "No role ID available"
            return
        
        response = self.make_request("GET", f"/admin/roles/{self.test_session.test_role_id}/permissions")
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Role permissions retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_assign_roles_to_user(self, result: TestResult):
        """Test: Assign Roles to User"""
        if not self.test_session.test_user_id or not self.test_session.test_role_id:
            result.status = TestStatus.SKIP
            result.message = "User ID or Role ID not available"
            return
        
        response = self.make_request("POST", f"/admin/users/{self.test_session.test_user_id}/roles", json={
            "role_ids": [self.test_session.test_role_id]
        })
        if response.status_code in [200, 201]:
            result.status = TestStatus.PASS
            result.message = "Roles assigned to user successfully"
        else:
            result.message = f"Expected 200/201, got {response.status_code}"

    # ==================== PERMISSION MANAGEMENT TESTS ====================

    def test_get_all_permissions(self, result: TestResult):
        """Test: Get All Permissions"""
        response = self.make_request("GET", "/admin/permissions")
        if response.status_code == 200:
            data = response.json()
            permissions = data.get("data", data.get("permissions", []))
            if permissions:
                self.test_session.test_permission_id = permissions[0].get("id")
            result.status = TestStatus.PASS
            result.message = f"Retrieved {len(permissions)} permissions"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_create_permission(self, result: TestResult):
        """Test: Create Permission"""
        permission_data = {
            "name": f"test_permission_{uuid.uuid4().hex[:8]}",
            "description": "Test permission for automation",
            "resource": "test",
            "action": "test"
        }
        
        response = self.make_request("POST", "/admin/permissions", json=permission_data)
        if response.status_code in [200, 201]:
            data = response.json()
            if data.get("permission"):
                self.test_session.test_permission_id = data["permission"].get("id")
            result.status = TestStatus.PASS
            result.message = "Permission created successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200/201, got {response.status_code}: {response.text}"

    # ==================== SETTINGS MANAGEMENT TESTS ====================

    def test_get_settings(self, result: TestResult):
        """Test: Get All Settings"""
        response = self.make_request("GET", "/admin/settings")
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Settings retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_update_settings(self, result: TestResult):
        """Test: Update Settings"""
        settings_data = {
            "game_multiplier": "10",
            "maximum_limit": "5000",
            "game_start_time": "08:00",
            "game_end_time": "22:00",
            "game_result_type": "manual"
        }
        
        response = self.make_request("PUT", "/admin/settings", json=settings_data)
        if response.status_code in [200, 201]:
            result.status = TestStatus.PASS
            result.message = "Settings updated successfully"
        else:
            result.message = f"Expected 200/201, got {response.status_code}"

    def test_get_settings_logs(self, result: TestResult):
        """Test: Get Settings Logs"""
        response = self.make_request("GET", "/admin/settings/logs?page=1&limit=10")
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Settings logs retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    # ==================== AUDIT LOGS TESTS ====================

    def test_get_audit_logs(self, result: TestResult):
        """Test: Get Audit Logs"""
        response = self.make_request("GET", "/admin/audit-logs?page=1&limit=10")
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Audit logs retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    # ==================== ADMIN GAME MANAGEMENT TESTS ====================

    def test_list_games(self, result: TestResult):
        """Test: List All Games (Admin)"""
        response = self.make_request("GET", "/admin/games?page=1&limit=20")
        if response.status_code == 200:
            data = response.json()
            games = data.get("data", [])
            if games:
                self.test_session.test_game_id = games[0].get("game_id")
            result.status = TestStatus.PASS
            result.message = f"Retrieved {len(games)} games"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_get_game_stats(self, result: TestResult):
        """Test: Get Game Statistics (Admin)"""
        if not self.test_session.test_game_id:
            result.status = TestStatus.SKIP
            result.message = "No game ID available"
            return
        
        response = self.make_request("GET", f"/admin/games/{self.test_session.test_game_id}/stats")
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Game statistics retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_get_game_bets(self, result: TestResult):
        """Test: Get Game Bets (Admin)"""
        if not self.test_session.test_game_id:
            result.status = TestStatus.SKIP
            result.message = "No game ID available"
            return
        
        response = self.make_request("GET", f"/admin/games/{self.test_session.test_game_id}/bets?page=1&limit=50")
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Game bets retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    def test_get_settlement_report(self, result: TestResult):
        """Test: Get Settlement Report (Admin)"""
        if not self.test_session.test_game_id:
            result.status = TestStatus.SKIP
            result.message = "No game ID available"
            return
        
        response = self.make_request("GET", f"/admin/games/{self.test_session.test_game_id}/settlement-report")
        if response.status_code == 200:
            data = response.json()
            result.status = TestStatus.PASS
            result.message = "Settlement report retrieved successfully"
            result.response_data = data
        else:
            result.message = f"Expected 200, got {response.status_code}"

    # ==================== SECURITY TESTS ====================

    def test_unauthorized_access(self, result: TestResult):
        """Test: Unauthorized Access Protection"""
        # Remove auth header
        if "Authorization" in self.session.headers:
            del self.session.headers["Authorization"]
        
        response = self.make_request("GET", "/admin/dashboard")
        if response.status_code == 401:
            result.status = TestStatus.PASS
            result.message = "Correctly requires authentication"
            # Restore token
            if self.test_session.admin_token:
                self.session.headers["Authorization"] = f"Bearer {self.test_session.admin_token}"
        else:
            result.message = f"Expected 401, got {response.status_code}"

    # ==================== RUN ALL TESTS ====================

    def run_all_tests(self):
        """Execute all admin panel test cases"""
        print("=" * 80)
        print("🧪 KismatX Admin Panel API Test Suite")
        print("=" * 80)
        print(f"Base URL: {BASE_URL}")
        print(f"Admin: {ADMIN_USERID}")
        print("=" * 80)

        # Authentication
        print("\n🔐 Authentication Tests")
        print("-" * 80)
        self.run_test("Admin Login", self.test_admin_login)

        # Dashboard
        print("\n📊 Dashboard Tests")
        print("-" * 80)
        self.run_test("Get Dashboard", self.test_get_dashboard)

        # User Management
        print("\n👥 User Management Tests")
        print("-" * 80)
        self.run_test("Get All Users", self.test_get_all_users)
        self.run_test("Create User", self.test_create_user)
        self.run_test("Get User by ID", self.test_get_user_by_id)
        self.run_test("Update User", self.test_update_user)
        self.run_test("Change User Status", self.test_change_user_status)
        self.run_test("Reset User Password", self.test_reset_user_password)
        self.run_test("Verify User Email", self.test_verify_user_email)
        self.run_test("Verify User Mobile", self.test_verify_user_mobile)
        self.run_test("Get User Login History", self.test_get_user_login_history)
        self.run_test("Kill User Sessions", self.test_kill_user_sessions)
        self.run_test("Get User Active Sessions", self.test_get_user_active_sessions)

        # Role Management
        print("\n🛡️ Role Management Tests")
        print("-" * 80)
        self.run_test("Get All Roles", self.test_get_all_roles)
        self.run_test("Create Role", self.test_create_role)
        self.run_test("Get Role Permissions", self.test_get_role_permissions)
        self.run_test("Assign Roles to User", self.test_assign_roles_to_user)

        # Permission Management
        print("\n🔑 Permission Management Tests")
        print("-" * 80)
        self.run_test("Get All Permissions", self.test_get_all_permissions)
        self.run_test("Create Permission", self.test_create_permission)

        # Settings Management
        print("\n⚙️ Settings Management Tests")
        print("-" * 80)
        self.run_test("Get Settings", self.test_get_settings)
        self.run_test("Update Settings", self.test_update_settings)
        self.run_test("Get Settings Logs", self.test_get_settings_logs)

        # Audit Logs
        print("\n📋 Audit Logs Tests")
        print("-" * 80)
        self.run_test("Get Audit Logs", self.test_get_audit_logs)

        # Admin Game Management
        print("\n🎮 Admin Game Management Tests")
        print("-" * 80)
        self.run_test("List All Games", self.test_list_games)
        self.run_test("Get Game Statistics", self.test_get_game_stats)
        self.run_test("Get Game Bets", self.test_get_game_bets)
        self.run_test("Get Settlement Report", self.test_get_settlement_report)

        # Security
        print("\n🔒 Security Tests")
        print("-" * 80)
        self.run_test("Unauthorized Access Protection", self.test_unauthorized_access)

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
        
        report_filename = f"admin_panel_test_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_filename, "w") as f:
            json.dump(self.report_data, f, indent=2)
        
        print("\n" + "=" * 80)
        print("📊 ADMIN PANEL TEST SUMMARY")
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
    suite = AdminPanelTestSuite()
    suite.run_all_tests()

