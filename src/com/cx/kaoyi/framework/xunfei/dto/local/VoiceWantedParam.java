package com.cx.kaoyi.framework.xunfei.dto.local;

import java.util.List;

public class VoiceWantedParam {
    private int speed;
    private int pitch;
    private int pause;
    private List<VoiceRoleParam> voiceRoleParam;

    public List<VoiceRoleParam> getVoiceRoleParam() {
        return voiceRoleParam;
    }

    public void setVoiceRoleParam(List<VoiceRoleParam> voiceRoleParam) {
        this.voiceRoleParam = voiceRoleParam;
    }

    public int getPitch() {
        return pitch;
    }

    public void setPitch(int pitch) {
        this.pitch = pitch;
    }

    public int getSpeed() {
        return speed;
    }

    public void setSpeed(int speed) {
        this.speed = speed;
    }

    public int getPause() {
        return pause;
    }

    public void setPause(int pause) {
        this.pause = pause;
    }
}
