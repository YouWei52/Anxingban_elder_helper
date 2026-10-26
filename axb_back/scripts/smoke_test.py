"""HTTP级冒烟测试"""
import sys
import httpx


def test_health_check(base_url: str = "http://127.0.0.1:8000"):
    """测试健康检查端点"""
    print("=" * 60)
    print("安行伴后端冒烟测试")
    print("=" * 60)

    try:
        # 测试根路径
        print(f"\n1. 测试根路径: {base_url}/")
        response = httpx.get(f"{base_url}/", timeout=5.0)
        print(f"   状态码: {response.status_code}")
        print(f"   响应: {response.json()}")
        assert response.status_code == 200
        print("   ✓ 通过")

        # 测试健康检查
        print(f"\n2. 测试健康检查: {base_url}/health")
        response = httpx.get(f"{base_url}/health", timeout=5.0)
        print(f"   状态码: {response.status_code}")
        print(f"   响应: {response.json()}")
        assert response.status_code == 200
        print("   ✓ 通过")

        # 测试API文档
        print(f"\n3. 测试API文档: {base_url}/docs")
        response = httpx.get(f"{base_url}/docs", timeout=5.0)
        print(f"   状态码: {response.status_code}")
        assert response.status_code == 200
        print("   ✓ 通过")

        print("\n" + "=" * 60)
        print("所有测试通过！✓")
        print("=" * 60)
        return True

    except httpx.ConnectError:
        print(f"\n✗ 无法连接到服务器 {base_url}")
        print("请确保服务已启动：uvicorn app.main:app --reload")
        return False
    except AssertionError as e:
        print(f"\n✗ 测试失败: {e}")
        return False
    except Exception as e:
        print(f"\n✗ 发生错误: {e}")
        return False


if __name__ == "__main__":
    base_url = sys.argv[1] if len(sys.argv) > 1 else "http://127.0.0.1:8000"
    success = test_health_check(base_url)
    sys.exit(0 if success else 1)
