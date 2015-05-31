<?php
// 本类由系统自动生成，仅供测试用途
class IndexAction extends Action {
    public function index(){
        $this->display();
    }
    // test方法
    public function test(){
        $i = '我再做测试！';
        $this->assign('test', $i);
        $this->display();
    }
    // urlpath测试
    function urlpath(){
        echo __URL__;
        echo '<br>utlpath';
    }
}
