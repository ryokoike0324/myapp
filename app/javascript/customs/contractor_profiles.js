// 受注者プロフィール画像のプレビューを表示する
document.addEventListener('DOMContentLoaded', () => {
    const fileInput = document.querySelector('input[type="file"]');
    if (fileInput) {
      fileInput.addEventListener('change', previewImage);
    }
  });
export function previewImage(event) {
    const target = event.target;
    const file = target.files[0];
    const reader  = new FileReader();
    reader.onloadend = function () {
        const preview = document.querySelector("#preview")
        if(preview) {
            preview.src = reader.result;
        }
    }
    if (file) {
        reader.readAsDataURL(file);
    }
}
// グローバルオブジェクトに渡さないとスコープの影響で関数が実行されない
window.previewImage = previewImage