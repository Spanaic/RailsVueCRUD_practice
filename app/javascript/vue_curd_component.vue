<template>
  <div>
    <p />
    <div
      class="fixed-bottom bg-dark text-white"
      v-bind:style="{ opacity: 0.55 }"
    >
      <span>&nbsp;</span>
      <span> {{ status }} </span>
    </div>
    <h3>投稿</h3>
    <p />
    <form v-on:submit.prevent="handleInsert">
      <input
        type="text"
        class="form-control"
        placeholder="名前"
        v-model="name"
      />
      <textarea
        class="form-control"
        rows="5"
        placeholder="コメントを入力して下さい。"
        v-model="comment"
      />
      <input type="submit" value="登録" class="btn btn-primary" />
    </form>
    <p />
    <h3>一覧</h3>
    <p />
    <div class="card-columns">
      <div v-for="(item, index) in items" :key="item.id">
        <!-- 表示モード -->
        <template v-if="!mode[index]">
          <div v-bind:key="item.id" class="card">
            <div class="card-header">
              {{ item.name }} <br />{{ formatConversion(item.updated_at) }}
            </div>
            <div class="card-body">
              {{ item.comment }}
              <br />
              <br />
              <form>
                <div v-bind:style="{ textAlign: 'right' }">
                  <input
                    type="submit"
                    value="編集"
                    class="btn btn-primary"
                    v-on:click.prevent="$root.$set(mode, index, !mode[index])"
                  />&nbsp;
                  <input
                    type="submit"
                    value="削除"
                    class="btn btn-danger"
                    v-on:click.prevent="handleDelete(index, item.id, $event)"
                  />&nbsp;&nbsp;
                </div>
              </form>
            </div>
          </div>
        </template>

        <!-- 編集モード -->
        <template v-else>
          <div v-bind:key="item.id" class="card">
            <form v-on:submit.prevent="handleUpdate(index, item.id, $event)">
              <div class="card_header">
                <input
                  type="text"
                  v-bind:value="item.name"
                  name="txt_name"
                  class="form-control"
                />
              </div>
              <div class="card_body">
                <textarea
                  v-bind:value="item.comment"
                  name="txt_comment"
                  class="form-control"
                  rows="5"
                />
              </div>
              <div v-bind:style="{ textAlign: 'right' }">
                <input
                  type="submit"
                  value="キャンセル"
                  class="btn btn-secondary"
                  v-on:click.prevent="$root.$set(mode, index, !mode[index])"
                />&nbsp;
                <input
                  type="submit"
                  value="更新"
                  class="btn btn-primary"
                />&nbsp;&nbsp;
              </div>
              <p />
            </form>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
// 日時操作
import { format } from "date-fns";
import ja from "date-fns/locale/ja";

export default {
  data: function() {
    return {
      items: [], // アイテム
      mode: [], // アイテムのモード(表示/編集)
      name: "", //　投稿 - 名前
      comment: "", // 投稿 - コメント
      status: "ここに「Ajax」に関するメッセージが表示されます。",
    };
  },
  // マウント
  mounted: function() {
    // jsonデータの取得
    fetch("http://localhost:3001/vue_crud_data/index.json")
      .then((res) => res.json())
      .then(
        (result) => {
          console.log("result", result);
          // リストデータ
          this.items = result;

          console.log("this.items", this.items);
          console.log(
            "formatConversion",
            this.formatConversion(this.items[0].updated_at)
          );

          // モードの初期化(全て表示モード)
          this.mode = Array(result.length).fill(false);
        },
        (error) => {
          this.status = error.message;
        }
      );
  },
  methods: {
    // Ajax通信(送信用)
    run_ajax: function(method, url, data) {
      fetch(url, {
        method: method,
        body: JSON.stringify(data),
        headers: {
          // JSON
          "Content-Type": "application/json",
          // CSRFトークン
          "X-CSRF-TOKEN": document
            .querySelector('meta[name ="csrf-token"]')
            .getAttribute("content"),
        },
      })
        .then((res) => res.json())
        .then(
          (result) => {
            this.status =
              "サーバーからのメッセージ(" +
              this.formatConversion(new Date()) +
              ") : " +
              result.registration;

            if (result.id) {
              if (result.id == "error") {
                // エラー制御は各自で実装（知見が無いので飛ばします)
                // 成功
              } else {
                // 先頭にアイテムを追加する
                this.items.unshift({
                  id: result.id,
                  name: result.name,
                  comment: result.comment,
                  updated_at: result.updated_at,
                });
                this.mode.unshift(false);
              }
              // 更新/削除
            } else {
              // エラー制御
            }
          },
          (error) => {
            this.status = error.message;
          }
        )
        .catch((error) => {
          this.status = error.message;
        });
    },

    // 日付操作
    formatConversion: function(updated_at) {
      console.log("updated_at", updated_at);
      return format(
        new Date(Date.parse(updated_at)),
        "yyyy年MM月dd日(iiii) HH:mm:ss",
        { locale: ja }
      );
    },

    // データの登録
    handleInsert(event) {
      if (this.name && this.comment) {
        // Ajax
        this.run_ajax("POST", "http://localhost:3001/vue_crud_data/", {
          datum: { name: this.name, comment: this.comment },
        });
        this.name = "";
        this.comment = "";
      }
    },

    // データの更新
    handleUpdate(index, id, event) {
      const form_data = new FormData(event.target);

      const txt_name = form_data.get("txt_name");
      const txt_comment = form_data.get("txt_comment");

      if (
        txt_name &&
        txt_comment &&
        !(
          this.items[index].name == txt_name &&
          this.items[index].comment == txt_comment
        )
      ) {
        this.$root.$set(this.items[index], "name", txt_name);
        this.$root.$set(this.items[index], "comment", txt_comment);
        this.$root.$set(this.items[index], "updated_at", new Date());

        // Ajax
        this.run_ajax("PUT", "http://localhost:3001/vue_crud_data/" + id, {
          datum: { name: txt_name, comment: txt_comment },
        });
      }
      // 表示モードを変更する
      this.$root.$set(this.mode, index, !this.mode[index]);
    },

    // データの削除
    handleDelete(index, id, event) {
      this.items.splice(index, 1);
      this.mode.splice(index, 1);

      // Ajax
      this.run_ajax("DELETE", "http://localhost:3001/vue_crud_data/" + id, {});
    },
  },

  computed: {
    // none
  },
};
</script>
