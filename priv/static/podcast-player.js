import {
  LitElement,
  html,
  css,
} from "https://unpkg.com/lit-element@3.2.0/lit-element.js?module";

class PodcastPlayer extends LitElement {
  static get properties() {
    return {
      currentTime: { type: String },
      currentSpeedIdx: { type: Number },
      duration: { type: String },
      title: { type: String },
      number: { type: String },
    };
  }

  static get styles() {
    return css`
      .sr-only {
        position: absolute;
        width: 1px;
        height: 1px;
        padding: 0;
        margin: -1px;
        overflow: hidden;
        clip: rect(0, 0, 0, 0);
        border: 0;
      }

      .podcast-player {
        --player-highlight: rgba(255, 255, 255, 0.3);
        --player-focus: rgba(255, 255, 255, 0.3);

        display: flex;
        flex-direction: column;

        width: 100%;
        padding: 4px 16px;
        box-sizing: border-box;
        border-radius: 3px;
        color: white;
      }
      .podcast-controls {
        display: flex;
        flex: 1;
        align-items: center;
        justify-content: center;
        gap: 12px;
      }
      @media screen and (min-width: 768px) {
        h1 {
          width: 320px;
        }
        .podcast-player {
          align-items: center;
          flex-direction: row;
        }
      }
      h1 {
        font-size: 14px;
        line-height: 1.2;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
      .number {
        display: block;
        margin-bottom: 4px;
        color: rgba(255, 255, 255, 0.5);
        font-weight: bold;
        font-size: 10px;
        text-transform: uppercase;
        letter-spacing: 1px;
      }
      .controls {
        display: flex;
      }
      :focus-visible {
        outline: none;
        box-shadow: 0 0 0px 5px var(--player-focus);
      }
      button {
        -webkit-appearance: none;
        font-family: inherit;
        border: 1px solid transparent;
        background-color: transparent;
        border-radius: 3px;
        cursor: pointer;
        color: currentColor;
      }
      .button-play {
        background: white;
        height: 42px;
        width: 42px;
        border-radius: 25px;
        display: flex;
        justify-content: center;
        align-items: center;
      }
      .button-play .play {
        position: relative;
        left: 2px;
      }
      .button-play svg {
        width: 16px;
        height: 16px;
      }
      .button-secondary {
        border-color: var(--player-highlight);
      }
      .button-secondary:focus-visible {
        border-color: var(--player-focus);
      }
      .timeline {
        flex: 1;
      }
      .times {
        display: flex;
        justify-content: space-between;
      }
      .time {
        font-size: 10px;
      }
      .speed-controls {
        display: flex;
        gap: 8px;
      }
      .speed-controls button {
        width: 48px;
        height: 36px;
      }
      input[type="range"] {
        -webkit-appearance: none;
        width: 100%;
        background: transparent;
      }
      input[type="range"]::-webkit-slider-runnable-track {
        width: 100%;
        height: 6px;
        cursor: pointer;
        animate: 0.2s;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 3px;
      }
      /* This is super weird, but combining this selector with the one
         above results in Safari not rendering the track. Similar
         case with the slider thumb below. */
      input[type="range"]::-moz-range-track {
        width: 100%;
        height: 6px;
        cursor: pointer;
        animate: 0.2s;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 3px;
      }
      input[type="range"]::-webkit-slider-thumb {
        border: none;
        height: 20px;
        width: 12px;
        border-radius: 13px;
        background: white;
        cursor: pointer;
        -webkit-appearance: none;
        margin-top: -9px;
      }
      input[type="range"]::-moz-range-thumb {
        border: none;
        height: 20px;
        width: 12px;
        border-radius: 13px;
        background: white;
        cursor: pointer;
        -webkit-appearance: none;
        margin-top: -9px;
      }
      input[type="range"]::-ms-fill-lower {
        background: var(--player-highlight);
      }
      input[type="range"]::-ms-fill-upper {
        background: white;
      }
      .button-speed:after {
        content: "x";
      }
      .button-play .pause {
        display: none;
      }
      :host(.is-playing) .button-play .pause {
        display: inline;
      }
      :host(.is-playing) .button-play .play {
        display: none;
      }
    `;
  }

  constructor() {
    super();

    // HTMLAudioElement
    this.audio = this.querySelector("audio");
    this.audio.controls = false;

    this.speeds = [1, 1.25, 1.5, 1.75, 2];
    this.currentSpeedIdx = 0;
    this.currentTime = 0;
    this.duration = 0;
    this.title = this.dataset.title;
    this.number = this.dataset.number;

    this.audio.addEventListener("timeupdate", this.handleTimeUpdate.bind(this));
    this.audio.addEventListener(
      "loadedmetadata",
      this.handleLoadedMetadata.bind(this)
    );
  }

  handleLoadedMetadata() {
    this.duration = this.audio.duration;
  }

  handleTimeUpdate(e) {
    this.currentTime = this.audio.currentTime;
  }

  toDurationString(secondsStr) {
    const pad = (num) => {
      const paddedString = `0${num}`;
      return paddedString.substring(paddedString.length - 2);
    };
    const seconds = parseInt(secondsStr, 10);
    const hh = Math.floor(seconds / (60 * 60));
    const remain = seconds % (60 * 60);
    const mm = Math.floor(remain / 60);
    const ss = Math.floor(remain % 60);
    return `${pad(hh)}:${pad(mm)}:${pad(ss)}`;
  }

  getSrc() {
    return this.audio.src;
  }

  setEpisode({ url, number, title }) {
    this.number = number;
    this.title = title;
    this.audio.src = url;
  }

  setEpisodeAndPlay({ url, number, title }) {
    if (this.getSrc() !== url) {
      this.setEpisode({ url, title, number });
    }
    if (this.isPaused()) {
      this.play();
    }
  }

  changeSpeed() {
    this.currentSpeedIdx =
      this.currentSpeedIdx + 1 < this.speeds.length
        ? this.currentSpeedIdx + 1
        : 0;
    this.audio.playbackRate = this.speeds[this.currentSpeedIdx];
  }

  rewind() {
    this.audio.currentTime -= 30;
  }

  ff() {
    this.audio.currentTime += 30;
  }

  isPaused() {
    return this.audio.paused;
  }

  play() {
    if (this.audio.paused) {
      this.audio.play();
      this.classList.add("is-playing");
    } else {
      this.audio.pause();
      this.classList.remove("is-playing");
    }
  }

  seek(e) {
    this.audio.currentTime = e.target.value;
  }

  render() {
    return html`
      <svg style="display: none;">
        <symbol id="icon-play" viewBox="0 0 39 46">
          <path
            d="M-2.5034e-06 0.483337L39 23L-2.31961e-06 45.5167L-2.5034e-06 0.483337Z"
            fill="black"
          />
        </symbol>
        <symbol id="icon-pause" viewBox="0 0 15 21">
          <path fill="black" d="M0 21V0H6V21H0Z" />
          <path fill="black" d="M15 0H9V21H15V0Z" />
        </symbol>
      </svg>

      <div class="podcast-player">
        <h1><span class="number">Jakso ${this.number}</span>${this.title}</h1>
        <div class="podcast-controls">
          <button
            type="button"
            class="button-play"
            aria-label="Toista"
            @click="${this.play}"
          >
            <svg class="play"><use xlink:href="#icon-play"></use></svg>
            <svg class="pause"><use xlink:href="#icon-pause"></use></svg>
          </button>

          <div class="timeline">
            <div class="times">
              <div>
                <span class="sr-only">Toistettu</span>
                <span class="time"
                  >${this.toDurationString(this.currentTime)}</span
                >
              </div>
              <div>
                <span class="sr-only">Kesto</span>
                <span class="duration time"
                  >${this.toDurationString(this.duration)}</span
                >
              </div>
            </div>
            <input
              type="range"
              class="progress-meter"
              value="${this.currentTime}"
              max="${this.duration}"
              @click="${this.seek}"
            />
          </div>

          <div class="speed-controls">
            <button
              type="button"
              class="button-speed button-secondary"
              @click="${this.changeSpeed}"
            >
              ${this.speeds[this.currentSpeedIdx]}
            </button>
            <button
              type="button"
              class="button-secondary"
              aria-label="30 sekuntia taaksepäin"
              @click="${this.rewind}"
            >
              -30s
            </button>
            <button
              type="button"
              class="button-secondary"
              aria-label="30 sekuntia eteenpäin"
              @click="${this.ff}"
            >
              +30s
            </button>
          </div>
        </div>
      </div>
    `;
  }
}

customElements.define("podcast-player", PodcastPlayer);
