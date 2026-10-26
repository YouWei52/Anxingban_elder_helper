"""
Mutmut 配置文件 - 用于过滤无意义的变异
"""

def pre_mutation(context):
    """
    在变异前调用，返回 context 继续变异，返回 None 跳过变异
    
    跳过的变异类型：
    1. Pydantic Field 的 description 参数
    2. APIRouter 的 tags 和 prefix 参数
    3. 日志消息字符串
    4. __tablename__ 属性
    5. 错误码枚举值（仅字符串内容，不包括变量名）
    6. 配置文件名
    """
    line = context.current_source_line.strip()
    
    # 跳过 Pydantic description 字段的字符串变异
    if 'description=' in line and 'Field(' in line:
        return None
    
    # 跳过 APIRouter 的 tags 参数
    if 'APIRouter(' in line and 'tags=' in line:
        return None
    
    # 跳过 APIRouter 的 prefix 参数（路由前缀）
    if 'APIRouter(' in line and 'prefix=' in line:
        return None
    
    # 跳过日志相关的字符串
    if any(keyword in line for keyword in ['logger.', 'logging.', '.info(', '.debug(', '.warning(', '.error(']):
        return None
    
    # 跳过 __tablename__ 的赋值
    if '__tablename__' in line:
        return None
    
    # 跳过错误码枚举的字符串值（但保留逻辑）
    if 'class ErrorCode' in context.current_source_file_path and '= "' in line and not line.strip().startswith('#'):
        # 只跳过简单的字符串赋值，不跳过逻辑判断
        if line.count('=') == 1 and line.count('"') == 2:
            return None
    
    # 跳过配置文件名
    if 'env_file=' in line:
        return None
    
    # 跳过 model_config 中的配置字符串
    if 'model_config' in line or 'SettingsConfigDict' in line:
        return None
    
    return context
