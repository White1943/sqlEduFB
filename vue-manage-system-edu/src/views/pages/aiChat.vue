<template>
    <div class="ai-chat-container">
        <!-- 模型选择 -->
        <div class="model-selector mb-4">
            <el-select v-model="selectedModel" placeholder="请选择对话模型">
                <el-option
                    v-for="model in models"
                    :key="model.id"
                    :label="model.model_name"
                    :value="model.model_identifier"
                >
                    <span>{{ model.model_name }}</span>
                    <span class="model-description">{{ model.description }}</span>
                </el-option>
            </el-select>
        </div>

        <!-- 对话历史 -->
        <div class="chat-history flex-1 space-y-6 overflow-y-auto rounded-xl bg-slate-200 p-4" ref="chatHistoryRef">
            <div v-for="(message, index) in chatHistory" 
                 :key="index" 
                 :class="['flex', message.role === 'user' ? 'items-start' : 'flex-row-reverse items-start']">
                <img
                    :class="message.role === 'user' ? 'mr-2 h-8 w-8' : 'ml-2 h-8 w-8'"
                    class="rounded-full"
                    :src="message.role === 'user' ? avatars.user : avatars.assistant"
                />
                <div
                    :class="[
                        'flex p-4 bg-white rounded-xl',
                        message.role === 'user' ? 'rounded-tr-xl rounded-b-xl' : 'rounded-tl-xl rounded-b-xl'
                    ]"
                >
                    <pre class="whitespace-pre-wrap">{{ message.content }}</pre>
                </div>
                
                <!-- 消息操作按钮 -->
                <div v-if="message.role === 'assistant'"
                     class="mr-2 mt-1 flex flex-col-reverse gap-2 text-gray-500">
                    <button class="hover:text-blue-600" @click="copyMessage(message.content)">
                        <i class="el-icon-document-copy"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- 输入区域 -->
        <div class="chat-input mt-4 flex gap-4">
            <el-input
                v-model="userInput"
                type="textarea"
                :rows="3"
                placeholder="请输入您的问题..."
                @keyup.enter.ctrl="sendMessage"
            />
            <el-button 
                type="primary" 
                :loading="loading"
                @click="sendMessage"
            >发送</el-button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue';
import { ElMessage } from 'element-plus';
import { getModels, sendChatMessage, getChatHistory } from '@/api/index';
import { formatDate } from '@/utils/date';
import userAvatar from '@/assets/img/user.png';
import aiAvatar from '@/assets/img/ai.png';

const selectedModel = ref('');
const models = ref([]);
const chatHistory = ref([]);
const userInput = ref('');
const loading = ref(false);
const chatHistoryRef = ref(null);

// 添加头像路径常量
const avatars = {
    user: userAvatar,
    assistant: aiAvatar
};

// 获取模型列表
const fetchModels = async () => {
    try {
        const response = await getModels();
        models.value = response.data.data;
        if (models.value.length > 0) {
            selectedModel.value = models.value[0].model_identifier;
        }
    } catch (error) {
        ElMessage.error('获取模型列表失败');
    }
};

// 获取历史对话
const fetchChatHistory = async () => {
    try {
        const response = await getChatHistory();
        chatHistory.value = response.data.data;
        await nextTick();
        scrollToBottom();
    } catch (error) {
        ElMessage.error('获取对话历史失败');
    }
};

// 发送消息
const sendMessage = async () => {
    if (!userInput.value.trim()) {
        ElMessage.warning('请输入内容');
        return;
    }
    if (!selectedModel.value) {
        ElMessage.warning('请选择对话模型');
        return;
    }

    loading.value = true;
    try {
        console.log('准备发送消息:', {
            model: selectedModel.value,
            messages: chatHistory.value
        });

        const response = await sendChatMessage({
            model: selectedModel.value,
            messages: [
                { role: 'system', content: 'You are a helpful assistant.' },
                ...chatHistory.value.map(msg => ({
                    role: msg.role,
                    content: msg.content
                })),
                { role: 'user', content: userInput.value }
            ]
        });
        
        console.log('服务器响应:', response);

        if (response.data.status === 'success') {
            // 添加用户消息到历史记录
            chatHistory.value.push({
                role: 'user',
                content: userInput.value
            });

            // 添加 AI 回复到历史记录
            chatHistory.value.push({
                role: 'assistant',
                content: response.data.response
            });
            
            userInput.value = '';
            await nextTick();
            scrollToBottom();
        } else {
            ElMessage.error(response.message || '发送消息失败');
        }
    } catch (error) {
        console.error('发送消息出错:', error);
        ElMessage.error('发送消息失败：' + (error.message || '未知错误'));
    } finally {
        loading.value = false;
    }
};

// 滚动到底部
const scrollToBottom = () => {
    if (chatHistoryRef.value) {
        chatHistoryRef.value.scrollTop = chatHistoryRef.value.scrollHeight;
    }
};

// 格式化时间
const formatTime = (time) => {
    return formatDate(new Date(time), 'YYYY-MM-DD HH:mm:ss');
};

const copyMessage = (content: string) => {
    navigator.clipboard.writeText(content);
    ElMessage.success('复制成功');
};

onMounted(() => {
    fetchModels();
    fetchChatHistory();
});
</script>

<style scoped>
.ai-chat-container {
    height: calc(100vh - 120px);
    padding: 20px;
    display: flex;
    flex-direction: column;
    background: #f5f7fa;
}

.model-selector {
    margin-bottom: 20px;
}

.chat-history {
    background: #f0f2f5;
    border-radius: 8px;
    padding: 20px;
    overflow-y: auto;
    flex: 1;
}

.chat-history pre {
    font-family: inherit;
    margin: 0;
}

.message {
    margin-bottom: 20px;
}

.message-content {
    display: flex;
    gap: 12px;
}

.message.user .message-content {
    flex-direction: row-reverse;
}

.message-text {
    max-width: 70%;
    padding: 12px;
    border-radius: 8px;
    background: white;
}

.message.assistant .message-text {
    background: #e8f5e9;
}

.message-time {
    font-size: 12px;
    color: #999;
    margin-top: 4px;
    text-align: center;
}

.chat-input {
    display: flex;
    gap: 12px;
}

.model-description {
    font-size: 12px;
    color: #999;
    margin-left: 8px;
}

pre {
    white-space: pre-wrap;
    word-wrap: break-word;
    margin: 0;
    font-family: inherit;
}
</style> 